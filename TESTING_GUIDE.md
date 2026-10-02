# SupplyGraph AI Testing Guide

Use this guide to prove that the interface is reading governed data from
Snowflake rather than the bundled demo snapshot.

## 1. Start the application

Confirm the workspace `.env` contains the real `SNOWFLAKE_ACCOUNT`,
`SNOWFLAKE_USER`, and `SNOWFLAKE_PASSWORD`. Do not share or commit that file.

Start FastAPI in the first PowerShell terminal:

```powershell
Set-Location backend
.\.venv\Scripts\python.exe -m uvicorn app.main:app --host 127.0.0.1 --port 8001
```

Expected output:

```text
Uvicorn running on http://127.0.0.1:8001
```

Start React in a second PowerShell terminal:

```powershell
Set-Location frontend
npm run dev -- --host 127.0.0.1
```

Open `http://127.0.0.1:5173`.

The first Snowflake connection can take one or two minutes. Wait until the
header changes from **Connecting** to **Live governed data**. If the header says
**Demo snapshot**, the live connection did not succeed.

## 2. Verify API connectivity

Open this URL in the browser:

```text
http://127.0.0.1:5173/api/health
```

Expected properties:

```json
{
  "status": "ok",
  "service": "SupplyGraph AI API",
  "environment": "development",
  "snowflake_configured": true
}
```

Then open:

```text
http://127.0.0.1:5173/api/dashboard/summary
```

The validated seed data currently returns these key values:

| Metric | Expected value |
| --- | ---: |
| Suppliers | 50 |
| Plants | 10 |
| Orders | 10,000 |
| At-risk parts | 554 |
| Affected orders | 49 |
| Overall on-time delivery | 77.17% |
| Fill rate | 96.15% |
| Defect rate | 20.00% |
| Total landed cost | USD 256,180,682.90 |

The Snowflake query results are the source of truth. If the governed dataset is
changed later, compare the API and Snowflake values rather than relying on the
fixed values in this table.

## 3. Verify dashboard behavior

Check the following in the application:

1. The header shows **Live governed data**.
2. The blue demo-snapshot alert is absent.
3. The KPI cards match `/api/dashboard/summary`.
4. The supplier table loads rows such as `S007` and `S019` from
   `GOVERNANCE.SUPPLIER_PERFORMANCE`.
5. The inventory section contains `STOCKOUT` rows with risk score `100` from
   `GOVERNANCE.PART_RISK`.
6. Navigation works for Overview, Suppliers, Inventory, and Ask SupplyGraph.
7. The mobile layout opens and closes its navigation menu without overlap.

## 4. Cross-check values in Snowflake

Run these read-only statements in a Snowflake worksheet:

```sql
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLYGRAPH_WH;
USE DATABASE SUPPLYGRAPH;
USE SCHEMA GOVERNANCE;

SELECT COUNT(*) AS supplier_count
FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER;

SELECT COUNT(*) AS plant_count
FROM SUPPLYGRAPH.GOVERNANCE.PLANT;

SELECT COUNT(*) AS order_count
FROM SUPPLYGRAPH.GOVERNANCE.ORDER_FULFILLMENT;

SELECT COUNT(*) AS at_risk_part_count
FROM SUPPLYGRAPH.GOVERNANCE.PART_RISK
WHERE risk_status <> 'HEALTHY';

SELECT
    ROUND(
        100.0 * SUM(on_time_shipments)
        / NULLIF(SUM(total_completed_shipments), 0),
        2
    ) AS on_time_delivery_rate
FROM SUPPLYGRAPH.GOVERNANCE.SUPPLIER_PERFORMANCE;

SELECT
    ROUND(
        100.0 * SUM(fulfilled_quantity)
        / NULLIF(SUM(ordered_quantity), 0),
        2
    ) AS fill_rate
FROM SUPPLYGRAPH.GOVERNANCE.ORDER_FULFILLMENT;
```

The worksheet results must match the corresponding API response and dashboard
cards.

## 5. Verify governed conversational analytics

In **Ask SupplyGraph**, select the Planning persona and ask:

```text
What is on-time delivery this month?
```

Expected validated result:

- Metric: **On-Time Delivery Rate**
- Value: **56.91%**
- Period: **September 2026**
- Canonical metric: `ON_TIME_DELIVERY_RATE`
- Source object: `GOVERNANCE.SUPPLIER_PERFORMANCE`
- Semantic view: `GOVERNANCE.SUPPLY_CHAIN_SV`
- Business owner: `Supply Chain Operations`
- SQL disclosure uses the approved OTD query over governed shipment data

Ask this indirect phrasing to validate live Cortex intent classification:

```text
How reliably did vendors honor their commitments in the latest month?
```

Expected: the same OTD result plus the **Cortex interpreted** badge. If Cortex
is unavailable, supported direct questions still work through deterministic
fallback and do not expose generated SQL.

Repeat the same question for Planning, Procurement, and Logistics. The metric,
value, evidence, SQL, and rows must remain identical. Only the final
persona-specific recommendation should change.

Also test:

```text
What is our overall fill rate?
How much is total landed cost?
How many customer orders are affected?
What is our defect rate?
What are our days of inventory?
```

## 6. Prove queries came from the application

Every application Snowflake connection sets `QUERY_TAG` to `SUPPLYGRAPH_AI`.
After loading the dashboard and asking a question, run:

```sql
SELECT
    start_time,
    query_tag,
    execution_status,
    query_text
FROM TABLE(
    SUPPLYGRAPH.INFORMATION_SCHEMA.QUERY_HISTORY(
        END_TIME_RANGE_START => DATEADD('hour', -1, CURRENT_TIMESTAMP()),
        RESULT_LIMIT => 100
    )
)
WHERE query_tag = 'SUPPLYGRAPH_AI'
ORDER BY start_time DESC;
```

Expected result: recent successful `SELECT` statements against approved
`SUPPLYGRAPH.GOVERNANCE` objects. This is the clearest evidence that the UI is
using Snowflake live data.

## 7. Run automated validation

Backend tests:

```powershell
Set-Location backend
.\.venv\Scripts\python.exe -m pytest -q
```

Expected: `12 passed`.

Frontend validation:

```powershell
Set-Location frontend
npm run lint
npm run build
npx playwright test tests/live-data.spec.ts --reporter=line --timeout=90000
```

Expected:

- ESLint completes without errors.
- Vite production build succeeds.
- Playwright reports `1 passed` after all three live dashboard APIs return
  status `200` and the interface shows **Live governed data**.

## 8. Acceptance criteria

The local prototype is ready to deploy when all of these are true:

- Health reports `snowflake_configured: true`.
- The UI shows **Live governed data**, not **Demo snapshot**.
- Dashboard values match direct governed Snowflake SQL.
- Query History shows successful queries tagged `SUPPLYGRAPH_AI`.
- Persona switching preserves the canonical metric and evidence.
- Backend, frontend, and Playwright validations all pass.