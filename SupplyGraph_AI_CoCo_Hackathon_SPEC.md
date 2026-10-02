# Snowflake CoCo CLI Hackathon 2026 — Build Specification

## 0. Purpose

This document is the implementation blueprint for building a submission for the **Snowflake CoCo CLI Hackathon — GCC Edition 2026**.

The current GCC-edition submission window runs through **4 October 2026**. The hackathon allows individual or team participation with teams of up to four members. The evaluation rubric is:

- Real-world relevance — 30%
- Technical execution — 40%
- Solution completeness — 30%

Source: Hack2Skill — Snowflake CoCo CLI Hackathon GCC Edition 2026.

---

# 1. Selected Problem Statement

## Supply Chain Ontology and Governed Conversational Analytics

### Official challenge

Supply-chain data is distributed across ERP, logistics, supplier and IoT systems with inconsistent definitions. The goal is to build an industry ontology and business-entity relationship model — for example:

`Supplier → Part → Plant → Shipment → Order → Customer`

The ontology should be expressed through governed semantic views so that a natural-language interface can return consistent, trustworthy answers grounded in shared definitions and metrics.

The implementation must demonstrate all of the following:

1. Core entities, relationships and business hierarchies.
2. Canonical metrics including On-Time Delivery, Fill Rate, Days of Inventory and Landed Cost.
3. Snowflake semantic views where business concepts, dimensions and metrics drive answers instead of raw column names.
4. Governed conversational analytics across supply-chain domains.
5. Identical metric resolution for planning, procurement and logistics personas.

### Our solution

Build:

# **SupplyGraph AI — Governed Supply Chain Intelligence Copilot**

A Snowflake-native AI application that lets operations and supply-chain users ask natural-language questions such as:

> Which suppliers are causing the highest delivery delays this month?

> Which parts are at risk of stockout in the next 14 days?

> Show plants with increasing shipment delays and explain the likely causes.

> Which suppliers have both poor delivery performance and increasing defect rates?

> What orders are affected by delayed shipments?

The system converts natural language into governed analytical queries, executes them against Snowflake, explains the results, and provides traceable evidence.

---

# 2. Why This Solution

The core problem is not simply "chat with a database".

Enterprise supply-chain analytics commonly has:

- multiple business entities
- inconsistent terminology
- different teams using different metric definitions
- structured transactional data
- operational events
- supplier performance data
- inventory data
- shipment data
- customer/order dependencies

A conversational layer without governance can produce misleading results.

SupplyGraph AI addresses this by creating:

1. A canonical supply-chain ontology.
2. Governed metric definitions.
3. Snowflake semantic/analytical views.
4. Natural-language question answering.
5. Evidence-backed responses.
6. Drill-down from business metric → entity → underlying records.
7. Optional anomaly/risk detection.
8. A web UI for business users.

---

# 3. High-Level Architecture

```text
                    ┌─────────────────────────┐
                    │       React UI           │
                    │  Chat + Dashboard        │
                    └────────────┬────────────┘
                                 │
                                 │ REST
                                 ▼
                    ┌─────────────────────────┐
                    │     FastAPI Backend      │
                    │                         │
                    │ Query Router             │
                    │ Guardrails               │
                    │ Response Formatter       │
                    │ Evidence Builder         │
                    └────────────┬────────────┘
                                 │
                ┌────────────────┼────────────────┐
                │                │                │
                ▼                ▼                ▼
        ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
        │ Snowflake    │ │ Cortex / AI  │ │ CoCo CLI     │
        │ SQL / Views  │ │ capabilities │ │ Development  │
        └──────┬───────┘ └──────────────┘ └──────────────┘
               │
               ▼
     ┌──────────────────────────────┐
     │ Canonical Supply Chain Model │
     │                              │
     │ Supplier                     │
     │ Part                         │
     │ Plant                        │
     │ Shipment                     │
     │ Order                        │
     │ Customer                     │
     │ Inventory                    │
     │ Quality Event                │
     └──────────────────────────────┘
```

---

# 4. Technology Stack

## Frontend

- React
- TypeScript
- Vite
- Material UI
- React Query
- Recharts
- Responsive design

## Backend

- Python
- FastAPI
- Pydantic
- Snowflake Python Connector
- Optional LangGraph only if it provides a clear benefit

## Data / AI

- Snowflake
- Snowflake SQL
- Snowflake semantic/governed views
- Snowflake Cortex capabilities where available
- CoCo CLI
- Optional RAG for business glossary/document context

## Development

- Git
- GitHub
- Docker
- GitHub Actions
- CoCo CLI

---

# 5. Repository Structure

```text
supplygraph-ai/
│
├── README.md
├── SPEC.md
├── ARCHITECTURE.md
├── DEMO_SCRIPT.md
├── SUBMISSION_CHECKLIST.md
├── docker-compose.yml
├── .env.example
├── .gitignore
│
├── frontend/
│   ├── package.json
│   ├── src/
│   │   ├── components/
│   │   │   ├── Chat/
│   │   │   ├── Dashboard/
│   │   │   ├── Evidence/
│   │   │   ├── EntityGraph/
│   │   │   └── Common/
│   │   ├── pages/
│   │   │   ├── ChatPage.tsx
│   │   │   ├── DashboardPage.tsx
│   │   │   └── EntityPage.tsx
│   │   ├── services/
│   │   │   └── api.ts
│   │   ├── hooks/
│   │   ├── types/
│   │   └── App.tsx
│   └── ...
│
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── config.py
│   │   ├── api/
│   │   │   ├── chat.py
│   │   │   ├── analytics.py
│   │   │   └── health.py
│   │   ├── services/
│   │   │   ├── query_router.py
│   │   │   ├── snowflake_service.py
│   │   │   ├── governance_service.py
│   │   │   ├── evidence_service.py
│   │   │   └── risk_service.py
│   │   ├── models/
│   │   └── prompts/
│   ├── requirements.txt
│   └── Dockerfile
│
├── snowflake/
│   ├── 00_setup.sql
│   ├── 01_tables.sql
│   ├── 02_seed_data.sql
│   ├── 03_relationships.sql
│   ├── 04_governed_views.sql
│   ├── 05_metrics.sql
│   ├── 06_risk_views.sql
│   └── 07_demo_queries.sql
│
├── data/
│   ├── suppliers.csv
│   ├── parts.csv
│   ├── plants.csv
│   ├── customers.csv
│   ├── orders.csv
│   ├── shipments.csv
│   ├── inventory.csv
│   └── quality_events.csv
│
├── docs/
│   ├── business-glossary.md
│   ├── ontology.md
│   └── architecture-diagram.md
│
└── tests/
    ├── backend/
    ├── frontend/
    └── sql/
```

---

# 6. Canonical Ontology

## Entities

### Supplier

Represents a company providing parts/materials.

Fields:

- supplier_id
- supplier_name
- region
- category
- supplier_status

### Part

Represents a manufactured or purchased component.

Fields:

- part_id
- part_name
- category
- criticality
- lead_time_days

### Plant

Represents a manufacturing/distribution location.

Fields:

- plant_id
- plant_name
- region
- capacity

### Shipment

Represents movement of parts/products.

Fields:

- shipment_id
- supplier_id
- part_id
- plant_id
- shipment_date
- expected_date
- actual_date
- status
- quantity
- material_cost
- freight_cost
- duty_cost
- insurance_cost
- handling_cost
- currency

### Order

Represents a customer/business order.

Fields:

- order_id
- customer_id
- plant_id
- order_date
- required_date
- status
- quantity
- fulfilled_quantity

### Customer

Fields:

- customer_id
- customer_name
- region
- segment

### Inventory

Fields:

- plant_id
- part_id
- available_quantity
- reserved_quantity
- reorder_point
- snapshot_date

### Quality Event

Fields:

- quality_event_id
- supplier_id
- part_id
- shipment_id
- defect_type
- severity
- event_date

---

# 7. Relationships

```text
Supplier
   │
   ├──────── supplies ───────► Part
   │                              │
   │                              │ used by
   │                              ▼
   │                           Plant
   │                              │
   │                              ├──── holds ───► Inventory
   │                              │
   │                              └──── fulfills ─► Order
   │                                                │
   │                                                ▼
   │                                            Customer
   │
   └──── sends ─────► Shipment ─────► Plant

Shipment ─────► Quality Event
Supplier ─────► Quality Event
Part ─────────► Quality Event
```

## Business hierarchies

```text
Geography: Region → Plant
Product: Category → Part
Supplier: Region → Category → Supplier
Customer: Region → Segment → Customer
Time: Year → Quarter → Month → Date
```

Hierarchy labels and keys must be represented in the governed semantic layer so conversational queries can aggregate and drill down consistently.

---

# 8. Governed Metrics

The system must NOT allow every question to invent its own metric definition.

Create a business glossary with canonical definitions.

## On-Time Delivery Rate

```text
on_time_shipments / total_completed_shipments * 100
```

A shipment is on time when:

```text
actual_date <= expected_date
```

## Average Delivery Delay

```text
AVG(
    DATEDIFF('day', expected_date, actual_date)
)
```

Only completed late shipments should contribute to the late-delay metric.

## Defect Rate

```text
defective_quantity / shipped_quantity * 100
```

## Inventory Coverage Days

```text
available_quantity / average_daily_demand
```

This is the canonical **Days of Inventory** metric named in the challenge. The governed display name is `Days of Inventory`; `Inventory Coverage Days` is an accepted synonym only.

## Fill Rate

```text
fulfilled_quantity / ordered_quantity * 100
```

The denominator includes order quantity in the selected period. The numerator includes the quantity fulfilled for those same order lines. Results must come from the governed order-fulfillment semantic view.

## Landed Cost

```text
material_cost
+ freight_cost
+ duty_cost
+ insurance_cost
+ handling_cost
```

The canonical shipment-level measure is Total Landed Cost. Landed Cost per Unit is:

```text
total_landed_cost / received_quantity
```

Currency and time filters must be explicit in evidence returned to users.

## Stockout Risk

A part is at stockout risk when projected available inventory falls below the defined safety threshold.

## Metric consistency across personas

Planning, procurement and logistics users may receive different explanatory context, but the same metric request with the same filters must resolve to the same:

- canonical metric name
- definition and formula
- approved semantic view
- time semantics
- filters
- numerical result

The automated acceptance test must ask the same On-Time Delivery question as all three personas and assert identical metric metadata and values.

## Semantic-view acceptance criteria

The implementation must include Snowflake semantic-view artifacts in addition to analytical and secure SQL views. At minimum, the semantic layer must expose:

- Supplier, Part, Plant, Shipment, Order and Customer entities
- entity relationships and business hierarchies
- On-Time Delivery Rate
- Fill Rate
- Days of Inventory
- Total Landed Cost and Landed Cost per Unit
- governed synonyms and time dimensions

Conversational queries must target this governed semantic layer rather than unrestricted RAW tables.

---

# 9. Natural Language Query Pipeline

```text
User question
      │
      ▼
Intent classification
      │
      ├── metric query
      ├── entity lookup
      ├── anomaly analysis
      ├── relationship query
      └── recommendation
      │
      ▼
Business glossary lookup
      │
      ▼
Ontology/entity resolution
      │
      ▼
Governed query generation
      │
      ▼
SQL validation
      │
      ▼
Snowflake execution
      │
      ▼
Evidence extraction
      │
      ▼
Answer generation
      │
      ▼
UI response
```

---

# 10. Guardrails

The backend must enforce:

1. SELECT-only analytical queries by default.
2. No arbitrary DDL/DML from the chat endpoint.
3. Only approved tables/views can be queried.
4. Metric definitions must come from the business glossary.
5. User questions must resolve to known entities/metrics.
6. SQL must be validated before execution.
7. Query timeout must be configured.
8. Result size must be limited.
9. Every answer should expose the source view/query used.
10. AI-generated SQL must never bypass application-level authorization.

---

# 11. Core User Experience

## Screen 1 — Dashboard

Show:

- Total suppliers
- On-time delivery %
- Average shipment delay
- Defect rate
- At-risk parts
- At-risk suppliers
- Open orders affected by delays

Charts:

- Delivery performance by supplier
- Delay trend
- Inventory risk
- Defect trend

---

# 12. Screen 2 — AI Copilot

Example:

```text
User:
Which suppliers are causing the highest delivery delays this month?
```

Response:

```text
Top contributors to delivery delays this month:

1. Supplier A
   Average delay: 5.8 days
   Late shipments: 34
   On-time delivery: 61%

2. Supplier B
   Average delay: 4.7 days
   Late shipments: 21
   On-time delivery: 68%

3. Supplier C
   Average delay: 4.2 days
   Late shipments: 18
   On-time delivery: 72%
```

Then show:

```text
Evidence
────────
View: GOVERNED_SUPPLIER_PERFORMANCE
Period: September 2026
Metric: Average Delivery Delay
Filters: Completed shipments
```

And:

```text
[View Data]
[Show SQL]
[Drill Down]
```

---

# 13. High-Value Demo Questions

The demo MUST support at least these queries.

### Query 1

> Which suppliers have the worst on-time delivery rate?

Expected capabilities:

- supplier ranking
- governed metric
- time filter
- evidence

### Query 2

> Which parts are at risk of stockout?

Expected capabilities:

- inventory analysis
- demand relationship
- risk classification
- affected plant

### Query 3

> Which suppliers have both poor delivery performance and high defect rates?

Expected capabilities:

- multi-metric correlation
- supplier entity resolution
- risk identification

### Query 4

> Which customer orders are affected by delayed shipments?

Expected capabilities:

```text
Shipment
   ↓
Part
   ↓
Plant
   ↓
Order
   ↓
Customer
```

### Query 5

> Explain why Plant P001 is experiencing delays.

Expected capabilities:

- shipment delays
- supplier contribution
- part contribution
- quality events
- inventory status

### Query 6

> What should the operations team investigate first?

Expected capabilities:

- risk prioritization
- supporting evidence
- explanation
- no unsupported claims

---

# 14. Example Risk Score

Create a transparent risk score instead of an unexplained AI score.

```text
risk_score =
    delivery_risk * 0.40
  + inventory_risk * 0.35
  + quality_risk * 0.25
```

Every component must be visible to the user.

Example:

```text
Supplier Risk: HIGH

Delivery risk:   82
Inventory risk:  71
Quality risk:    63

Final score:     74.7
```

---

# 15. Evidence-First Responses

Every analytical response should follow:

```text
Answer
↓
Key numbers
↓
Reasoning
↓
Evidence
↓
Source view
↓
Optional SQL
↓
Drill-down
```

Do NOT produce unsupported statements such as:

> "Supplier A is unreliable because they have poor management."

Instead:

> "Supplier A has the highest average delivery delay in the selected period. The dataset shows 34 late shipments with an average delay of 5.8 days."

---

# 16. Synthetic Dataset

Do NOT use confidential enterprise data.

Generate realistic synthetic data.

Minimum target:

```text
Suppliers:       50
Parts:           300
Plants:          10
Customers:       500
Orders:          10,000
Shipments:       15,000
Inventory rows:  5,000
Quality events:  3,000
```

Create deliberate patterns:

- 3 high-risk suppliers
- 5 high-risk parts
- 2 plants with increasing delays
- several delayed shipments
- several quality clusters
- inventory shortages
- orders affected by late shipments

The dataset should contain enough signal for the demo questions to produce meaningful results.

---

# 17. Snowflake Data Model

Recommended database:

```text
SUPPLYGRAPH
```

Schema:

```text
RAW
ANALYTICS
GOVERNANCE
```

Example tables:

```text
RAW.SUPPLIERS
RAW.PARTS
RAW.PLANTS
RAW.CUSTOMERS
RAW.ORDERS
RAW.SHIPMENTS
RAW.INVENTORY
RAW.QUALITY_EVENTS
```

Governed views:

```text
GOVERNANCE.SUPPLIER_PERFORMANCE
GOVERNANCE.PART_RISK
GOVERNANCE.PLANT_PERFORMANCE
GOVERNANCE.ORDER_IMPACT
GOVERNANCE.SUPPLY_CHAIN_360
```

---

# 18. Business Glossary

Create:

```text
docs/business-glossary.md
```

Example:

```text
Metric: On-Time Delivery Rate

Definition:
Percentage of completed shipments delivered on or before expected date.

Formula:
on_time_shipments / completed_shipments * 100

Approved source:
GOVERNANCE.SUPPLIER_PERFORMANCE
```

The AI layer must use these definitions rather than inventing alternatives.

---

# 19. CoCo CLI Development Workflow

Use CoCo CLI as the primary AI-assisted development workflow.

Recommended sequence:

```text
1. Understand SPEC.md
2. Inspect repository
3. Create architecture
4. Implement Snowflake schema
5. Generate synthetic data
6. Implement governed views
7. Implement FastAPI
8. Implement query routing
9. Implement React UI
10. Add tests
11. Run end-to-end validation
12. Prepare demo
13. Prepare submission
```

---

# 20. GitHub Copilot Master Prompt

Paste this into GitHub Copilot Chat/Agent mode after adding this file to the repository:

```text
You are the lead engineer for this project.

Read SPEC.md completely before making any changes.

We are building SupplyGraph AI, a Snowflake-native governed supply-chain conversational analytics application for the Snowflake CoCo CLI Hackathon GCC Edition 2026.

Primary objective:
Build a working end-to-end prototype, not a mockup.

Technology:
- React + TypeScript
- Vite
- Material UI
- Python FastAPI
- Snowflake
- Snowflake SQL
- Snowflake Cortex capabilities where available
- Docker
- CoCo CLI

Engineering requirements:
1. Follow SPEC.md as the source of truth.
2. Do not invent architecture that conflicts with SPEC.md.
3. Prefer simple production-grade implementations.
4. Keep business logic separated from UI.
5. Keep Snowflake SQL in the snowflake/ directory.
6. Keep API models strongly typed with Pydantic.
7. Keep frontend types synchronized with API contracts.
8. Add error handling.
9. Add tests for important functionality.
10. Never hard-code Snowflake credentials.
11. Use .env for secrets.
12. Never commit secrets.
13. Do not use confidential data.
14. Use synthetic supply-chain data.
15. Every AI answer must provide evidence/source information.
16. Do not allow arbitrary destructive SQL through the AI interface.
17. Use governed views for analytical responses.
18. Make the demo flow reliable before adding optional features.

Development strategy:
- First inspect the repository.
- Then create/update the implementation plan.
- Implement one vertical slice at a time.
- After every major step, run relevant tests.
- Do not modify unrelated files.
- Explain blockers before making risky architectural changes.

Vertical slices:

Slice 1:
Snowflake setup + tables + seed data.

Slice 2:
Governed views + canonical metrics.

Slice 3:
FastAPI health check + Snowflake connection.

Slice 4:
Analytics endpoints.

Slice 5:
Natural-language query pipeline.

Slice 6:
Evidence response format.

Slice 7:
React dashboard.

Slice 8:
React AI copilot.

Slice 9:
Drill-down and evidence UI.

Slice 10:
Risk analytics.

Slice 11:
Tests.

Slice 12:
Docker + README + demo preparation.

Before each slice:
- inspect existing code
- identify files to change
- implement the smallest complete change
- test it
- report the result

Do not generate a giant amount of code in one response.
```

---

# 21. CoCo CLI Prompt

Use this as the initial CoCo CLI instruction:

```text
Read SPEC.md.

You are the technical lead for SupplyGraph AI.

First:
1. Inspect the repository.
2. Identify the current implementation state.
3. Create an implementation plan based on SPEC.md.
4. Identify missing Snowflake objects.
5. Identify missing backend APIs.
6. Identify missing frontend components.
7. Identify missing tests.

Do not write implementation code yet.

Return:
- current state
- architecture gaps
- implementation phases
- risks
- recommended first vertical slice
```

Then:

```text
Implement Phase 1 from the approved plan.

Requirements:
- Keep changes limited to Phase 1.
- Follow SPEC.md.
- Generate production-quality code.
- Add tests where applicable.
- Do not introduce unnecessary dependencies.
- Validate the implementation before finishing.
```

---

# 22. API Contract

## POST /api/chat

Request:

```json
{
  "question": "Which suppliers have the worst delivery performance this month?"
}
```

Response:

```json
{
  "answer": "Supplier A has the lowest on-time delivery rate...",
  "intent": "SUPPLIER_PERFORMANCE",
  "metrics": [
    {
      "name": "On-Time Delivery Rate",
      "value": 61.2,
      "unit": "%"
    }
  ],
  "evidence": {
    "view": "GOVERNANCE.SUPPLIER_PERFORMANCE",
    "period": "September 2026"
  },
  "sql": "SELECT ...",
  "rows": []
}
```

---

# 23. API Endpoints

Implement:

```text
GET  /api/health

GET  /api/dashboard/summary

GET  /api/suppliers

GET  /api/suppliers/{supplier_id}

GET  /api/parts/risk

GET  /api/plants/performance

GET  /api/orders/impact

POST /api/chat
```

Optional:

```text
POST /api/risk/analyze
```

---

# 24. UI Requirements

## Dashboard

The first screen should immediately communicate:

```text
Supply Chain Health
────────────────────────────────────

Suppliers       50
Plants          10
Orders          10K+
At-Risk Parts   17

On-Time Delivery       82.4%
Avg Delay               2.1 days
Defect Rate             1.8%
```

Then:

- supplier performance chart
- inventory risk chart
- delay trend
- top risks

---

# 25. AI Copilot UI

Design:

```text
┌───────────────────────────────────────────────┐
│ SupplyGraph AI                                │
├───────────────────────────────────────────────┤
│                                               │
│ Ask about your supply chain...                │
│                                               │
│ [ Which suppliers are causing delays? ]       │
│                                               │
├───────────────────────────────────────────────┤
│ AI Response                                   │
│                                               │
│ Supplier A has the highest average delay...   │
│                                               │
│ ┌───────────────────────────────────────────┐ │
│ │ Evidence                                  │ │
│ │ View: SUPPLIER_PERFORMANCE                │ │
│ │ Period: September 2026                    │ │
│ └───────────────────────────────────────────┘ │
│                                               │
│ [View SQL] [View Data] [Drill Down]           │
└───────────────────────────────────────────────┘
```

---

# 26. Testing Strategy

## Backend

Test:

- Snowflake connection abstraction
- metric calculations
- query validation
- SQL safety
- intent routing
- response formatting

## Frontend

Test:

- dashboard rendering
- chat submission
- loading state
- error state
- evidence rendering
- SQL rendering
- drill-down navigation

## End-to-End

Test:

```text
User question
→ API
→ governed query
→ Snowflake
→ evidence
→ UI
```

---

# 27. Security

Never commit:

```text
SNOWFLAKE_PASSWORD
SNOWFLAKE_PRIVATE_KEY
API_KEYS
TOKENS
```

Use:

```text
.env
.env.example
```

`.env.example`:

```text
SNOWFLAKE_ACCOUNT=
SNOWFLAKE_USER=
SNOWFLAKE_PASSWORD=
SNOWFLAKE_DATABASE=SUPPLYGRAPH
SNOWFLAKE_SCHEMA=GOVERNANCE
SNOWFLAKE_WAREHOUSE=
```

Add `.env` to `.gitignore`.

---

# 28. Demo Story

The demo should follow a business narrative.

## Step 1

Open dashboard.

Say:

> "This dashboard provides a governed view of supply-chain health."

## Step 2

Ask:

> "Which suppliers are causing the highest delivery delays?"

Show:

- supplier
- delay
- on-time rate
- evidence

## Step 3

Ask:

> "Which parts are at risk of stockout?"

Show:

- part
- plant
- current inventory
- projected risk

## Step 4

Ask:

> "Which suppliers have both poor delivery performance and high defect rates?"

Show correlation.

## Step 5

Ask:

> "Which customer orders are affected?"

Drill from:

```text
Supplier
→ Part
→ Shipment
→ Plant
→ Order
→ Customer
```

## Step 6

Ask:

> "What should the operations team investigate first?"

Show transparent risk factors.

## Step 7

Click:

```text
Show Evidence
```

Demonstrate:

- governed view
- metric definition
- SQL
- source records

This is the key trust differentiator.

---

# 29. What NOT to Build

Avoid spending hackathon time on:

- generic chatbot
- login system
- complex user management
- mobile app
- unnecessary microservices
- custom LLM training
- overly complex RAG
- huge datasets
- elaborate animations
- unrelated AI agents
- autonomous actions that are difficult to demo
- features that cannot be reliably demonstrated

Focus on:

```text
Governance
+
Ontology
+
Natural language
+
Snowflake analytics
+
Evidence
+
Business usefulness
```

---

# 30. MVP Definition

The MVP is complete when all of these work:

- [ ] Snowflake database created
- [ ] Synthetic data loaded
- [ ] Ontology implemented
- [ ] Governed views implemented
- [ ] Canonical metrics implemented
- [ ] FastAPI connected to Snowflake
- [ ] Natural-language question endpoint works
- [ ] At least 5 demo questions work
- [ ] Evidence is displayed
- [ ] React dashboard works
- [ ] AI copilot works
- [ ] SQL is visible
- [ ] Drill-down works
- [ ] Tests exist
- [ ] README exists
- [ ] Architecture diagram exists
- [ ] Demo script exists
- [ ] No secrets committed

---

# 31. Stretch Features

Only implement these after the MVP is stable.

## A. Supply Chain Graph

Visualize:

```text
Supplier → Part → Plant → Shipment → Order → Customer
```

## B. Anomaly Detection

Detect:

- sudden delivery degradation
- unusual defect spikes
- inventory drops
- shipment delay clusters

## C. What-if Analysis

Example:

> What happens to affected orders if Supplier A is delayed by another 5 days?

## D. Automated Alerts

Optional:

```text
High-risk supplier detected
        ↓
Generate explanation
        ↓
Create alert
        ↓
Display in dashboard
```

## E. Business Glossary Assistant

Allow:

> What does On-Time Delivery Rate mean?

Return the governed definition.

---

# 32. Submission Checklist

Before submission:

### Functional

- [ ] Application starts from clean setup
- [ ] Snowflake setup script works
- [ ] Synthetic data loads
- [ ] Dashboard works
- [ ] Chat works
- [ ] At least five questions work
- [ ] Evidence works
- [ ] Drill-down works

### Engineering

- [ ] README complete
- [ ] Architecture documented
- [ ] Environment setup documented
- [ ] Tests included
- [ ] Docker setup included if used
- [ ] No secrets
- [ ] No confidential data
- [ ] Error handling implemented

### Demo

- [ ] 3–5 minute demo flow prepared
- [ ] Demo dataset preloaded
- [ ] Questions tested beforehand
- [ ] Screenshots recorded
- [ ] Backup screenshots/video available
- [ ] Architecture diagram ready

### Hackathon

- [ ] Correct GCC problem statement selected
- [ ] CoCo CLI usage demonstrated/documented
- [ ] Submission form completed
- [ ] Repository URL ready
- [ ] Demo URL/video ready if required
- [ ] Final submission checked before deadline

---

# 33. Execution Plan

## Day 1 — Foundation

```text
Create repository
Create SPEC.md
Create Snowflake database
Create tables
Generate synthetic data
Load data
```

## Day 2 — Governance

```text
Create ontology
Create business glossary
Create governed views
Create canonical metrics
Create demo SQL
```

## Day 3 — Backend

```text
FastAPI
Snowflake service
Analytics endpoints
Chat endpoint
Query validation
Evidence response
```

## Day 4 — Frontend

```text
Dashboard
Chat interface
Evidence panel
SQL panel
Drill-down
Risk dashboard
```

## Day 5 — AI + Integration

```text
Natural-language routing
Governed query generation
Cortex integration where applicable
End-to-end flow
```

## Day 6 — Hardening

```text
Testing
Error handling
Docker
README
Architecture
Demo script
```

## Day 7 — Submission

```text
Full clean setup
Run demo
Record demo
Fix only critical issues
Final git push
Submit
```

---

# 34. Definition of Done

The project is considered complete when a new user can:

```text
Clone repository
     ↓
Configure environment
     ↓
Run Snowflake setup
     ↓
Start backend
     ↓
Start frontend
     ↓
Open dashboard
     ↓
Ask a supply-chain question
     ↓
Receive a governed answer
     ↓
Inspect evidence
     ↓
Drill into affected entities
```

The system must demonstrate that the AI is not merely generating conversational text.

It must connect:

```text
Natural Language
       ↓
Business Ontology
       ↓
Governed Metrics
       ↓
Snowflake Data
       ↓
Evidence
       ↓
Actionable Insight
```

---

# 35. Final Principle

Build less, but make the important path work extremely well.

The winning demo narrative should be:

> "We don't just let users ask Snowflake questions. We give the AI a governed understanding of the supply chain, so every answer is grounded in shared business definitions, relationships and evidence."

---

## Official reference

Snowflake CoCo CLI Hackathon — GCC Edition 2026:
Hack2Skill official event page.
