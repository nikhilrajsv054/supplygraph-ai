# SupplyGraph AI Presentation Notes

Target duration: **4 minutes** plus questions.

## Slide 1 — Cover (0:00–0:15)

> I am Nikhilraj SV from NOVA-AgenticIQ. SupplyGraph AI addresses the Supply
> Chain Ontology and Governed Conversational Analytics challenge with a live,
> evidence-backed Snowflake control tower.

## Slide 2 — Problem Brief (0:15–0:40)

> Planning, procurement, and logistics often calculate the same KPI
> differently across fragmented systems. Generic text-to-SQL adds another risk:
> a plausible answer without an auditable definition or source. We replace that
> ambiguity with one governed answer for every persona.

## Slide 3 — Supply-chain Ontology (0:40–1:05)

> The canonical model connects suppliers, parts, inventory, plants, shipments,
> orders, customers, and quality events. This lets a user move from a network
> metric to operational cause and customer impact without changing definitions.

## Slide 4 — Live Control Tower (1:05–1:35)

> This is the live product, not a mockup. Snowflake currently reports 77.17%
> on-time delivery, 96.15% fill rate, and 554 at-risk part locations. The same
> governed data drives the supplier watchlist, inventory exposure, and order
> impact views.

## Slide 5 — Governed AI Architecture (1:35–2:10)

> Cortex interprets language into only an approved metric and period. Pydantic
> validates that structure, and the repository selects fixed governed SQL.
> Cortex never writes SQL or changes data. Invalid AI output falls back to
> deterministic intent matching, preserving availability and trust.

## Slide 6 — Evidence (2:10–2:40)

> Every answer returns its metric definition, formula, period, source object,
> semantic view, SQL, and rows. Here, the September 2026 on-time delivery result
> is 56.91%, and the evidence is visible beside the answer instead of hidden.

## Slide 7 — Persona Consistency (2:40–3:00)

> Planning, procurement, and logistics receive recommendations appropriate to
> their responsibilities. The value, definition, evidence, SQL, and source rows
> remain identical. Persona changes context, never metric truth.

## Slide 8 — Impact and Scale (3:00–3:20)

> The governed model covers 50 suppliers, 10 plants, 10,000 customer orders,
> 554 risk locations, 49 affected orders, and $256.2 million in landed cost.
> These values are returned from live Snowflake objects and cross-checked
> through the API.

## Slide 9 — Engineering Readiness (3:20–3:40)

> Trust is enforced through 12 backend tests, a live browser flow, fixed SQL,
> query tagging, runtime secrets, and the read-only SUPPLYGRAPH_APP role. A
> multi-stage Docker image and Render blueprint provide the deployment path.

## Slide 10 — Thank You (3:40–4:00)

> SupplyGraph AI is governed, operational, and extensible. It connects the
> network, preserves one metric truth, and makes every answer auditable. That is
> how conversational analytics becomes usable for real supply-chain decisions.

Pause on the closing statement, then move to the live demonstration or Q&A.