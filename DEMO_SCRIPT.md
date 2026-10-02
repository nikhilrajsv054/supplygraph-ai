# SupplyGraph AI Demo Script

Target duration: 3–5 minutes.

## Before Recording

1. Confirm Snowflake warehouse `SUPPLYGRAPH_WH` is running.
2. Start FastAPI on port `8001` and React on port `5173`.
3. Wait until the header says `Live governed data`.
4. Test every question below once to warm the Snowflake connection.
5. Keep backup screenshots and the official presentation deck open.

## 0:00–0:30 — Business Problem

Say:

> Supply-chain teams often disagree because planning, procurement, and
> logistics calculate the same KPI differently. SupplyGraph AI gives every
> persona one governed Snowflake definition and shows the evidence behind each
> answer.

Show the dashboard header and `Live governed data` badge.

## 0:30–1:20 — Network Pulse

Show:

- On-time delivery
- Fill rate
- At-risk part locations
- Total landed cost
- Supplier delay watchlist and affected orders

Say:

> The control tower joins supplier, part, plant, shipment, order, customer,
> inventory, and quality data through governed Snowflake views.

## 1:20–2:20 — Governed Conversation

Select `Planning`, then ask:

> What is on-time delivery this month?

Point out the answer and its September 2026 period. Open the evidence section
and show the canonical definition, formula, source object, semantic view,
filters, business owner, SQL, and result row.

Say:

> The assistant does not generate arbitrary SQL. It resolves this question to
> an approved metric query and returns an auditable evidence package.

## 2:20–3:00 — Persona Consistency

Repeat the same question for `Procurement` and `Logistics`.

Say:

> The recommendation wording changes for the user’s responsibility, but the
> metric value, definition, evidence, SQL, and rows stay identical.

## 3:00–3:40 — Cross-Domain Questions

Ask two or three of these:

- What is our overall fill rate?
- How many customer orders are affected?
- What is our defect rate?
- How much is total landed cost?
- What are our days of inventory?

Connect each result to the dashboard’s operational signals.

## 3:40–4:20 — Technical Proof

Show the architecture slide or diagram.

Say:

> React calls FastAPI, FastAPI enforces typed contracts and fixed intent
> routing, and Snowflake answers only from governed analytical objects and the
> formal supply-chain semantic view. CoCo CLI supported the SQL, semantic-model,
> application, and validation workflow.

## 4:20–4:40 — Close

Say:

> SupplyGraph AI turns fragmented supply-chain records into consistent,
> evidence-backed decisions. It is useful today as a control tower and provides
> a governed foundation for broader enterprise AI workflows.

## Backup Plan

If Snowflake cold-starts during the recording, pause after opening the app and
wait for `Live governed data`. If connectivity fails, explicitly identify the
visible `Demo snapshot` label and use the backup screenshots; never describe
snapshot values as live.
