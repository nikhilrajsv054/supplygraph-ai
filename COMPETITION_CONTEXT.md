# Snowflake CoCo CLI Hackathon 2026 — GCC Edition

## Competition Context, Rules, Problem Statements, Evaluation, Submission Requirements & Build Guidance

> **Purpose of this document:** This file is the competition-level context for an AI coding agent such as GitHub Copilot or Snowflake CoCo CLI.  
> It explains **what the competition is, who can participate, what must be built, the official problem statements, deadlines, judging rules, submission requirements, restrictions, prizes, and what our implementation must optimize for**.
>
> **Important:** This document is based on the official Hack2Skill GCC Edition event page and the linked official Terms & Conditions. The Terms & Conditions are the controlling rules if there is any conflict.

---

# 1. Competition Identity

**Competition:** Snowflake CoCo CLI Hackathon 2026 — GCC Edition

**Organizer / administration:** YourStory + Hack2Skill, with Snowflake as sponsor.

**Theme:** Build enterprise-ready AI applications using Snowflake CoCo CLI and Snowflake's AI/Data platform.

**Format:** Online, with a virtual Grand Finale for shortlisted finalists.

**Eligibility:** India GCC developers/practitioners for the GCC Edition.

**Team size:** 1–4 members.

**Minimum age:** 18+.

**Registration fee:** None.

**Prize pool:** USD $10,000.

The official event page describes the challenge as a build-first innovation program focused on practical, production-oriented AI applications rather than ideas alone.

---

# 2. The Core Goal of the Competition

The competition is NOT simply:

> "Build a chatbot using an LLM."

The intended goal is:

```text
Real enterprise problem
        ↓
Business/data understanding
        ↓
Snowflake data platform
        ↓
CoCo CLI / AI development
        ↓
AI reasoning / intelligent workflow
        ↓
Working application
        ↓
Useful business outcome
```

The solution should demonstrate:

- Practical business relevance
- Real data usage
- AI integration
- Snowflake usage
- Working end-to-end functionality
- Strong technical implementation
- Clear user experience
- Explainable/reliable outputs
- A prototype that can actually be demonstrated

---

# 3. Critical Official Requirements

According to the official Terms & Conditions, an eligible entry must satisfy important requirements including:

1. The solution must respond to one of the designated hackathon themes/problem statements.
2. The prototype must use **Cortex Code CLI / CoCo CLI** as required by the competition.
3. **Snowflake platform usage is required.**
4. The official judging criteria specifically mention programming languages:
   - Python
   - Java
   - Scala
5. Special consideration is given to entries incorporating:
   - Snowpark
   - Worksheets
   - Streamlit
   - Snowflake Marketplace
6. A complete source-code repository must be provided.
7. A presentation deck must be submitted.
8. Finalists must be prepared for a live virtual demonstration.
9. All entry material and presentations must be in English.
10. Only one entry is allowed per participant/team.
11. Confidential/proprietary/unauthorized data must not be used.
12. Third-party datasets/APIs/code must comply with their licenses and terms.

**Implementation implication:** Do not build a generic React/LLM application and merely mention Snowflake in the README. Snowflake and CoCo CLI need to be meaningful parts of the actual solution.

---

# 4. Eligibility

## 4.1 Geographic eligibility

The GCC Edition is open to eligible participants in India.

The official Terms & Conditions also define a broader eligible territory list for the underlying contest, including India and specified APJ countries. For this project, follow the GCC Edition registration eligibility shown on the official event page.

## 4.2 Age

Participant must be at least 18 years old at the beginning of the Submission Period.

## 4.3 Professional background

The event is intended for people with experience in:

- Software engineering
- Data engineering
- Data science
- AI/ML
- Backend/application development
- Enterprise technology

## 4.4 Team

Allowed:

```text
Individual
OR
2 people
OR
3 people
OR
4 people
```

Maximum:

```text
4 members
```

Each participant may participate in only **one entry**, whether individually or as part of a team.

---

# 5. Important Ineligibility Rules

According to the official Terms & Conditions, certain people cannot participate, including:

- Current Snowflake employees
- Employees of the contest administrator involved in administration
- Contest judges
- Certain employees of entities in which the sponsor has an ownership interest
- Immediate family/household members of specified ineligible persons
- Persons on applicable restricted/prohibited party lists
- Persons outside the eligible territories
- Anyone whose participation is prohibited by applicable law

Participants are responsible for checking their own employment agreements, company policies, local laws, and prize eligibility.

---

# 6. Official Timeline — GCC Edition

All official contest times are in **India Standard Time (IST)** unless otherwise specified.

| Event                       | Date                            |
| --------------------------- | ------------------------------- |
| Registration begins         | 15 June 2026                    |
| Problem Statement Explainer | 6 August 2026, 4:00–5:00 PM IST |
| CoCo CLI Starter Workshop   | 12 August 2026                  |
| CoCo CLI Hands-on Workshop  | 19 August 2026                  |
| Registration ends           | 30 September 2026               |
| Prototype Submission Period | 13 September – 4 October 2026   |
| Prototype Evaluation        | 5 – 22 October 2026             |
| Final Shortlist             | Around 23 October 2026          |
| Finalist Induction          | 26 October 2026                 |
| Grand Finale Demo Days      | 27 – 30 October 2026            |
| Contest period ends         | 30 October 2026, 11:59 PM IST   |

### Hard submission deadline

According to the official Terms & Conditions:

```text
4 October 2026
11:59 PM IST
```

The official contest computer is the authoritative clock.

**Do not wait until the last hour.**

---

# 7. Competition Phases

```text
Registration
     ↓
Problem Statement / Enablement
     ↓
Prototype Development
     ↓
Submission
     ↓
Evaluation
     ↓
Final Shortlist
     ↓
Finalist Induction
     ↓
Grand Finale
     ↓
Winner Selection
```

---

# 8. Official Problem Statements

The current GCC Edition page lists **five** problem statements.

## Problem 1 — Risk, Fraud and Regulatory Intelligence Copilot

### Business problem

Banking and NBFC teams deal with:

- Real-time fraud
- Liquidity risk
- Credit risk
- AML
- Basel requirements
- Local regulatory reporting

Much of the work can be manual.

### Required direction

Build a copilot that:

- Surfaces risk/fraud signals
- Lets users ask questions in natural language
- Produces audit-ready regulatory outputs
- Connects business data with AI reasoning

Potential architecture:

```text
Transactions
     +
Customer data
     +
Risk signals
     +
Regulatory documents
     ↓
Snowflake
     ↓
AI / CoCo CLI
     ↓
Risk reasoning
     ↓
Audit-ready output
```

---

# 9. Problem 2 — Customer 360 and Next Best Action Engine

### Business problem

Insurers and lenders need unified customer information for:

- Personalization
- Underwriting
- Churn reduction
- Customer service
- Relationship management

Data may exist across:

- Customer profiles
- Transactions
- Claims
- Support tickets
- Call transcripts
- Emails
- Product usage

### Required direction

Build an application that:

1. Unifies structured and unstructured customer touchpoints.
2. Creates a customer 360 view.
3. Uses AI to understand the customer.
4. Recommends a next best action.

Example:

```text
Customer
   ├── Profile
   ├── Transactions
   ├── Calls
   ├── Claims
   ├── Support
   └── Product usage
             ↓
        Customer 360
             ↓
        AI reasoning
             ↓
     Next Best Action
```

---

# 10. Problem 3 — Predictive Maintenance and OEE Command Center

### Business problem

Manufacturers lose value because of unplanned equipment downtime.

Operational technology (OT) sensor data can be disconnected from:

- ERP
- Maintenance records
- Production data
- Work orders

### Required direction

Build a solution that:

1. Combines IT and OT data.
2. Detects/predicts equipment failure.
3. Provides maintenance intelligence.
4. Can automate or recommend work orders.
5. Helps improve Overall Equipment Effectiveness (OEE).

Example:

```text
IoT Sensors
    +
Machine telemetry
    +
Production data
    +
Maintenance history
    +
ERP
    ↓
Snowflake
    ↓
AI / Analytics
    ↓
Failure prediction
    ↓
Maintenance action
    ↓
OEE improvement
```

---

# 11. Problem 4 — Patient and Member 360 and Clinical/Regulatory Document Copilot

### Business problem

Healthcare and life-sciences organizations work across:

- EHR data
- Claims
- Clinical information
- Regulatory documents
- Safety documents
- Other unstructured content

### Required direction

Build a copilot that:

- Creates patient/member 360
- Combines structured and unstructured information
- Answers clinical/safety/regulatory questions
- Provides cited evidence

### Critical data rule

The official problem statement explicitly says:

```text
Use fully synthetic or de-identified data only.
```

Never use real confidential patient data.

---

# 12. Problem 5 — Supply Chain Ontology and Governed Conversational Analytics

### Business problem

Supply-chain information can be distributed across:

- ERP
- Logistics
- Supplier systems
- IoT
- Inventory
- Orders

Different teams can define the same metric differently.

Example:

One team says:

```text
On-time delivery = shipment before expected date
```

Another team might use:

```text
On-time delivery = shipment before requested delivery date
```

This creates inconsistent answers.

### Required direction

Build:

1. An industry ontology.
2. A business entity model.
3. Relationships between entities.
4. Governed semantic views.
5. A natural-language interface.
6. Consistent answers using shared metrics/definitions.

Example relationship:

```text
Supplier
   ↓
Part
   ↓
Plant
   ↓
Shipment
   ↓
Order
   ↓
Customer
```

This is the problem statement selected for our project.

---

# 13. Selected Project

## SupplyGraph AI

### Problem Statement

**Supply Chain Ontology and Governed Conversational Analytics**

### Project objective

Build a Snowflake-native supply-chain intelligence application where users can ask natural-language questions and receive answers grounded in:

- A canonical ontology
- Governed business definitions
- Snowflake data
- Semantic/analytical views
- Evidence
- Traceable calculations

The system should not behave like a generic chatbot.

---

# 14. Why Our Project Fits the Challenge

We should demonstrate:

```text
Supply-chain entities
        ↓
Relationships
        ↓
Governed semantic layer
        ↓
Natural-language interface
        ↓
Snowflake query
        ↓
Evidence
        ↓
Business insight
```

Example:

> Which suppliers are causing the highest delivery delays?

The system should resolve:

```text
supplier
+
delivery delay
+
time period
```

then map those concepts to governed definitions and execute a Snowflake query.

---

# 15. Judging

## Official Hack2Skill Evaluation Rubric

| Criterion             | Weight |
| --------------------- | -----: |
| Real-World Relevance  |    30% |
| Technical Execution   |    40% |
| Solution Completeness |    30% |

These are the headline weights shown on the official GCC Edition event page.

---

# 16. Official Terms & Conditions — Technical Judging Requirements

The official Terms & Conditions additionally state that judges consider whether:

1. The Idea/Prototype responds to the designated theme.
2. CoCo/Cortex Code CLI is used.
3. Programming languages include Python, Java and/or Scala.
4. Snowflake is used.
5. Special consideration is given to:
   - Snowpark
   - Worksheets
   - Streamlit
   - Snowflake Marketplace

### Important implementation decision

Our project should therefore make the Snowflake/Python/CoCo CLI relationship obvious.

Recommended:

```text
CoCo CLI
   ↓
Development / orchestration
   ↓
Python
   ↓
Snowflake
   ↓
Governed analytics
   ↓
Application
```

For the prototype, Snowpark and/or Streamlit can be included where useful, without unnecessarily replacing the main application architecture.

---

# 17. What "Real-World Relevance" Means for Our Project

The solution should answer a real enterprise question.

Weak:

> Chat with supply-chain data.

Stronger:

> Help supply-chain operations teams identify which suppliers, parts and plants are creating delivery risk, trace affected orders, and investigate the underlying evidence.

Demonstrate:

- Business user
- Business problem
- Data
- AI reasoning
- Decision
- Evidence
- Action

---

# 18. What "Technical Execution" Means for Our Project

The implementation should demonstrate:

### Data architecture

- Snowflake
- Relational data model
- Entity relationships
- Governed views
- Metrics

### AI

- Natural-language understanding
- Query generation/reasoning
- Entity resolution
- Business glossary grounding
- Evidence generation

### Application

- React UI
- FastAPI
- API contracts
- Error handling
- Loading states
- Security

### Engineering

- Git
- Tests
- Documentation
- Reproducible setup
- Environment configuration

---

# 19. What "Solution Completeness" Means for Our Project

The prototype should work from start to finish.

```text
User
 ↓
UI
 ↓
Question
 ↓
AI interpretation
 ↓
Ontology resolution
 ↓
Governed metric
 ↓
Snowflake query
 ↓
Result
 ↓
Evidence
 ↓
Business explanation
 ↓
Drill-down
```

Avoid a project where:

- UI is fake
- AI responses are hard-coded
- Snowflake is only mentioned in README
- SQL is not actually executed
- Data is not reproducible
- Demo depends on manual hidden steps

---

# 20. Entry Requirements

The official Terms & Conditions state that an Entry includes:

- Complete participant/team profile
- Idea
- Prototype, where applicable
- Presentation materials
- Source-code link/repository or source files, as applicable

## Verified submission portal fields

The Hack2Skill **GitHub/Deployed Link** module shown on 1 October 2026 requires:

- Challenge selection
- A public GitHub repository URL
- A deployed prototype URL

The module closes on **4 October 2026 at 11:59 PM IST**. Both URL fields are mandatory and accept up to 1,024 characters.

The presentation deck remains a required submission artifact, but it is handled separately from the GitHub/Deployed Link module shown in the portal screenshot. Verify the deck upload module before final submission.

### Implementation consequence

The project is not submission-ready with local source code or a localhost demo alone. Before submission:

```text
Public GitHub repository
+
Publicly reachable deployed prototype
+
Presentation deck
```

Test both submitted URLs in a private/incognito browser window without relying on a developer session.

Once the Submission Period ends, the Entry cannot be changed or updated.

### Therefore

Before submission, verify:

```text
[ ] Idea complete
[ ] Prototype working
[ ] GitHub repository public and accessible
[ ] Prototype deployed at a publicly reachable URL
[ ] README complete
[ ] Architecture documented
[ ] Presentation complete
[ ] Demo tested
[ ] Data sources documented
[ ] Licenses documented
[ ] No secrets
```

---

# 21. Language Requirement

All Entries and oral presentations must be in:

```text
English
```

This includes:

- README
- Presentation
- Demo narration
- Submitted written material

---

# 22. Snowflake Trial Account

The official Terms & Conditions state that Snowflake provides a free trial account for the contest.

The Terms specify:

```text
$400 USD credit
```

for the contest trial account.

Participants must use the signup flow provided by the contest and accept the applicable Snowflake trial terms.

### Important

Do not assume the trial credit is unlimited.

Design the application to be:

- Cost-conscious
- Efficient
- Reproducible
- Easy to reset

---

# 23. Dataset Rules

Participants may use:

- Sponsor-provided datasets
- Public datasets
- Public APIs
- Other datasets where the participant has the necessary rights/licenses

Participants are responsible for:

- Dataset licensing
- API terms
- API rate limits
- Credentials
- Privacy
- Attribution
- Compliance

### Never use

- Confidential company data
- Proprietary employer data without authorization
- Personal data without appropriate rights
- Unauthorized datasets
- Copyrighted material without permission
- Secrets/API keys in Git

For healthcare use cases, use only synthetic/de-identified data as explicitly required.

---

# 24. Third-Party API Rules

Third-party APIs are allowed where permitted.

However:

```text
Participant
    ↓
Responsible for API
    ├── Credentials
    ├── Rate limits
    ├── Terms
    ├── License
    ├── Privacy
    └── Attribution
```

Do not make the demo completely dependent on an unreliable external free API.

If an external API is used:

- Cache important demo data.
- Have a fallback.
- Document it.
- Do not commit credentials.

---

# 25. Intellectual Property

The official Terms & Conditions state that applicable intellectual-property rights in an Entry remain with the participant/team, subject to the license granted to the sponsor/administrator.

By entering, participants grant the sponsor/administrator a royalty-free, non-exclusive, worldwide, irrevocable, sublicensable license to use, host, reproduce, modify, distribute, display, perform, create derivative works from, and otherwise exploit the Entry for specified promotional, evaluation, internal business, demonstration, marketing and related purposes.

### Practical implication

Do not put proprietary employer technology or confidential company information into the project.

Use:

- Original implementation
- Synthetic data
- Public/licensed data
- Properly licensed libraries

---

# 26. Originality Rules

The submission must be original with respect to its creative/substantive elements.

Third-party components are allowed only when used according to their licenses/terms.

Do not:

- Copy another team's solution
- Plagiarize code
- Submit someone else's project
- Include confidential material
- Misrepresent third-party work as your own

Using AI coding assistants does not remove the responsibility to understand and validate the code you submit.

---

# 27. Source Code Requirement

A complete source-code repository must be available to judges.

Recommended repository:

```text
supplygraph-ai/
├── README.md
├── SPEC.md
├── ARCHITECTURE.md
├── DEMO_SCRIPT.md
├── SUBMISSION_CHECKLIST.md
│
├── frontend/
├── backend/
├── snowflake/
├── data/
├── docs/
└── tests/
```

The repository should allow a technical reviewer to understand:

```text
What?
Why?
How?
How to run?
How does Snowflake work?
How does CoCo CLI fit?
Where is AI used?
Where is governance implemented?
How is the result validated?
```

---

# 28. Presentation Deck Requirement

The official Terms require a presentation deck outlining:

- Idea
- Approach
- Thought process

Recommended deck:

### Slide 1 — Title

```text
SupplyGraph AI
Governed Conversational Supply Chain Intelligence
```

### Slide 2 — Problem

Show fragmented supply-chain systems.

### Slide 3 — Solution

Show SupplyGraph AI.

### Slide 4 — Architecture

```text
React
 ↓
FastAPI
 ↓
AI / CoCo CLI
 ↓
Snowflake
 ↓
Governed Views
 ↓
Supply Chain Data
```

### Slide 5 — Ontology

```text
Supplier → Part → Plant → Shipment → Order → Customer
```

### Slide 6 — AI Flow

Show:

```text
Question
→ Intent
→ Entity resolution
→ Metric resolution
→ SQL
→ Snowflake
→ Evidence
→ Answer
```

### Slide 7 — Demo

Show the application.

### Slide 8 — Business Impact

Explain what operations teams can accomplish.

### Slide 9 — Technical Implementation

Show Snowflake, CoCo CLI, Python, APIs, semantic layer.

### Slide 10 — Future Scope

Show:

- Alerts
- What-if analysis
- More supply-chain entities
- Predictive analytics
- Automated workflows

---

# 29. Live Demo Requirement

For finalists, the official rules require a live demonstration in a virtual setting.

Do not rely on a fragile setup.

Prepare:

```text
Primary environment
+
Backup environment
+
Screenshots
+
Demo dataset
+
Known-good queries
```

### Demo should be rehearsed

Do not experiment with new prompts during the final demo.

---

# 30. Recommended Demo Flow

Target a concise business story.

## Step 1 — Dashboard

Show:

- Supply-chain health
- Delivery performance
- Inventory risk
- Quality risk

## Step 2 — Ask

> Which suppliers are causing the highest delivery delays this month?

Show:

- Supplier
- Delay
- On-time rate
- Evidence

## Step 3 — Ask

> Which parts are at risk of stockout?

Show:

- Part
- Plant
- Inventory
- Risk

## Step 4 — Ask

> Which suppliers have both poor delivery performance and high defect rates?

Show multi-metric reasoning.

## Step 5 — Ask

> Which customer orders are affected by delayed shipments?

Drill:

```text
Supplier
→ Part
→ Shipment
→ Plant
→ Order
→ Customer
```

## Step 6 — Evidence

Show:

- Governed view
- Metric definition
- SQL
- Source records

This demonstrates trust and governance.

---

# 31. Snowflake Usage Must Be Meaningful

Do NOT create this:

```text
React
 ↓
OpenAI
 ↓
Hardcoded JSON

Snowflake → only README
```

Instead:

```text
React
 ↓
FastAPI
 ↓
AI/query layer
 ↓
Governed Snowflake views
 ↓
Snowflake data
 ↓
Evidence
```

Snowflake should be part of the actual computation.

---

# 32. CoCo CLI Must Be Meaningful

CoCo CLI should not merely appear in the documentation.

Use it for the actual development workflow and demonstrate the resulting solution's use of the required Snowflake/Cortex tooling.

Recommended project documentation:

```text
docs/coco-cli-workflow.md
```

Include:

- Setup
- Commands used
- Development workflow
- Relevant prompts
- Generated/modified components
- How the solution uses Snowflake

Do not fabricate usage logs or claims.

---

# 33. Recommended Technology Stack

## Frontend

```text
React
TypeScript
Vite
Material UI
React Query
Recharts
```

## Backend

```text
Python
FastAPI
Pydantic
Snowflake Connector
```

## Snowflake

```text
Snowflake
Snowpark where useful
SQL
Governed views
Worksheets
Streamlit where useful
```

## AI

```text
CoCo CLI
Snowflake Cortex capabilities where applicable
LLM / natural-language query layer
Business glossary grounding
```

---

# 34. Architecture Principle

Use the simplest architecture that clearly satisfies the challenge.

Recommended:

```text
                   ┌───────────────────────┐
                   │       React UI        │
                   └───────────┬───────────┘
                               │
                               ▼
                   ┌───────────────────────┐
                   │      FastAPI          │
                   └───────────┬───────────┘
                               │
                ┌──────────────┼──────────────┐
                ▼              ▼              ▼
        ┌──────────────┐ ┌────────────┐ ┌─────────────┐
        │ Query/AI     │ │ Governance │ │ Evidence    │
        │ Layer        │ │ Layer      │ │ Layer       │
        └──────┬───────┘ └─────┬──────┘ └──────┬──────┘
               │               │               │
               └───────────────┼───────────────┘
                               ▼
                     ┌──────────────────┐
                     │    Snowflake     │
                     │                  │
                     │ Raw              │
                     │ Analytics        │
                     │ Governed Views   │
                     └──────────────────┘
```

---

# 35. Recommended Snowflake Structure

```text
SUPPLYGRAPH
│
├── RAW
│   ├── SUPPLIERS
│   ├── PARTS
│   ├── PLANTS
│   ├── CUSTOMERS
│   ├── ORDERS
│   ├── SHIPMENTS
│   ├── INVENTORY
│   └── QUALITY_EVENTS
│
├── ANALYTICS
│   ├── SUPPLIER_METRICS
│   ├── PART_METRICS
│   ├── PLANT_METRICS
│   └── ORDER_IMPACT
│
└── GOVERNANCE
    ├── SUPPLIER_PERFORMANCE
    ├── PART_RISK
    ├── PLANT_PERFORMANCE
    ├── ORDER_IMPACT
    └── SUPPLY_CHAIN_360
```

---

# 36. Business Ontology

Core entities:

```text
Supplier
Part
Plant
Shipment
Order
Customer
Inventory
Quality Event
```

Relationships:

```text
Supplier
  └── supplies → Part

Part
  └── stored/used at → Plant

Supplier
  └── sends → Shipment

Shipment
  └── arrives at → Plant

Shipment
  └── contains → Part

Plant
  └── fulfills → Order

Order
  └── belongs to → Customer

Shipment
  └── may generate → Quality Event
```

---

# 37. Governance Model

Every metric must have:

```text
Metric name
Definition
Formula
Source view
Time semantics
Filters
Owner/business meaning
```

Example:

```text
Metric:
On-Time Delivery Rate

Definition:
Percentage of completed shipments delivered on or before expected date.

Formula:
on_time_shipments / completed_shipments * 100

Source:
GOVERNANCE.SUPPLIER_PERFORMANCE
```

---

# 38. AI Guardrails

The AI layer must:

- Prefer governed views.
- Resolve business terminology.
- Validate SQL.
- Restrict access to approved objects.
- Prevent destructive SQL.
- Limit query results.
- Handle ambiguous questions.
- State assumptions.
- Show evidence.
- Avoid inventing facts.
- Never expose credentials.

Example:

User:

> Show me unreliable suppliers.

Better response:

> "Unreliable" is not a governed metric. I can show suppliers with the lowest On-Time Delivery Rate or highest Average Delivery Delay. Which metric should I use?

This demonstrates enterprise-grade behavior.

---

# 39. Evidence Requirement

Every important AI answer should contain:

```text
Answer
↓
Metrics
↓
Source
↓
Time period
↓
Filters
↓
Optional SQL
↓
Underlying records
```

Example:

```text
Finding:
Supplier S014 has the lowest on-time delivery rate.

Metric:
On-Time Delivery Rate = 61.2%

Period:
September 2026

Source:
GOVERNANCE.SUPPLIER_PERFORMANCE

Evidence:
34 late shipments
Average delay = 5.8 days
```

---

# 40. Synthetic Data Strategy

Use synthetic data if real enterprise data is unavailable.

Recommended minimum:

```text
50 suppliers
300 parts
10 plants
500 customers
10,000 orders
15,000 shipments
5,000 inventory records
3,000 quality events
```

Create realistic patterns:

- Several high-risk suppliers
- Several delayed shipments
- Inventory shortages
- Quality-event clusters
- Plants with rising delays
- Customer orders affected by delays

The data should be intentionally designed so that the demo questions have meaningful answers.

---

# 41. Project Repository Rules

Never commit:

```text
.env
API keys
Snowflake passwords
private keys
access tokens
employer confidential files
```

Use:

```text
.env.example
```

Example:

```text
SNOWFLAKE_ACCOUNT=
SNOWFLAKE_USER=
SNOWFLAKE_PASSWORD=
SNOWFLAKE_DATABASE=SUPPLYGRAPH
SNOWFLAKE_SCHEMA=GOVERNANCE
SNOWFLAKE_WAREHOUSE=
```

---

# 42. GitHub Copilot Instructions

When using GitHub Copilot Agent/Chat, always tell it:

```text
Read COMPETITION_CONTEXT.md before implementing anything.

This is a Snowflake CoCo CLI Hackathon 2026 GCC Edition submission.

The official competition requirements are more important than generic software-development preferences.

Do not:
- remove Snowflake
- replace Snowflake with another database
- turn the application into a generic chatbot
- use confidential data
- hardcode credentials
- invent unsupported competition requirements
- add unnecessary technologies

Do:
- keep Snowflake central
- use Python/Java/Scala where appropriate
- make CoCo CLI usage meaningful
- follow the selected problem statement
- prioritize a working end-to-end prototype
- document all datasets and licenses
- create reproducible setup
- add tests
- prepare the project for a technical judge
```

---

# 43. CoCo CLI Initial Prompt

Use:

```text
Read COMPETITION_CONTEXT.md completely.

You are the lead engineer helping build a submission for the Snowflake CoCo CLI Hackathon 2026 GCC Edition.

Before writing code:

1. Understand the competition.
2. Understand the official requirements.
3. Understand the selected problem statement.
4. Understand the judging criteria.
5. Inspect the repository.
6. Identify the current implementation state.
7. Create a phased implementation plan.

The selected challenge is:

Supply Chain Ontology and Governed Conversational Analytics.

The application must:
- use Snowflake meaningfully
- use CoCo CLI meaningfully
- use Python where appropriate
- create a supply-chain ontology
- implement governed metrics/views
- provide a natural-language interface
- return evidence-backed answers
- be demonstrable end-to-end

Do not implement yet.

Return:
1. Competition constraints
2. Architecture
3. Missing components
4. Implementation phases
5. Risks
6. First vertical slice
```

---

# 44. Copilot Development Order

Do NOT ask an AI agent to build everything in one shot.

Build in vertical slices.

## Phase 1

```text
Repository
+
Snowflake setup
+
Tables
+
Synthetic data
```

## Phase 2

```text
Ontology
+
Business glossary
+
Governed views
+
Metrics
```

## Phase 3

```text
FastAPI
+
Snowflake connector
+
Health endpoint
+
Analytics endpoints
```

## Phase 4

```text
Natural-language query pipeline
+
Intent resolution
+
Metric resolution
+
SQL generation
+
SQL validation
```

## Phase 5

```text
Evidence response
+
Source views
+
SQL display
+
Underlying records
```

## Phase 6

```text
React dashboard
+
Charts
+
Risk cards
```

## Phase 7

```text
AI Copilot
+
Chat
+
Evidence
+
Drill-down
```

## Phase 8

```text
Testing
+
Security
+
Docker
+
Documentation
```

## Phase 9

```text
Presentation
+
Demo script
+
Final submission
```

---

# 45. What We Should Avoid

Avoid spending the majority of the hackathon on:

- Authentication
- Complex RBAC
- Mobile applications
- Microservices
- Kubernetes
- Custom LLM training
- Huge datasets
- Fancy animations
- Unnecessary agent frameworks
- Generic RAG
- Features unrelated to the selected problem

The competition is about solving the designated enterprise problem using Snowflake/CoCo CLI.

---

# 46. What Would Make the Prototype Technically Strong

Prioritize:

```text
1. Snowflake integration
2. Correct data model
3. Ontology
4. Governed metrics
5. Natural-language interaction
6. Evidence
7. Reliable SQL
8. AI reasoning
9. Business workflow
10. Excellent demo
```

---

# 47. Strong Differentiator

A generic AI application might say:

> "Supplier A is performing poorly."

SupplyGraph should say:

```text
Supplier A

On-Time Delivery:
61.2%

Average Delay:
5.8 days

Late Shipments:
34

Defect Rate:
4.7%

Affected Parts:
12

Affected Plants:
3

Affected Orders:
184

Source:
GOVERNANCE.SUPPLIER_PERFORMANCE

Metric Definition:
On-Time Delivery = completed shipments delivered
on or before expected date.
```

This demonstrates:

```text
AI
+
Data
+
Governance
+
Traceability
```

---

# 48. Final Demo Narrative

The story should be:

> "Supply-chain teams often have the data but not a consistent way to reason over it. SupplyGraph AI creates a governed ontology over suppliers, parts, plants, shipments, orders and customers. Users can ask natural-language questions, and the system maps those questions to governed business metrics and Snowflake data, returning not only an answer but the evidence behind it."

Then demonstrate:

```text
Question
 ↓
Understanding
 ↓
Ontology
 ↓
Governed Metric
 ↓
Snowflake
 ↓
Evidence
 ↓
Insight
 ↓
Drill-down
```

---

# 49. Final Submission Checklist

## Competition

- [ ] Registered
- [ ] Eligibility confirmed
- [ ] Team size ≤ 4
- [ ] Only one entry per participant
- [ ] Correct problem statement selected

## Prototype

- [ ] Working application
- [ ] Snowflake actually used
- [ ] CoCo CLI actually used
- [ ] Python/Java/Scala requirement addressed
- [ ] At least one strong end-to-end workflow
- [ ] No hardcoded secrets
- [ ] No confidential data

## Data

- [ ] Data sources documented
- [ ] Licenses documented
- [ ] API terms checked
- [ ] Synthetic/de-identified data where required

## Repository

- [ ] GitHub repository accessible
- [ ] README
- [ ] Setup instructions
- [ ] Architecture
- [ ] Source code
- [ ] Tests
- [ ] `.env.example`
- [ ] No `.env`

## Presentation

- [ ] Idea
- [ ] Problem
- [ ] Architecture
- [ ] Approach
- [ ] Thought process
- [ ] Demo
- [ ] Technical implementation
- [ ] Business value

## Demo

- [ ] Demo environment works
- [ ] Snowflake account works
- [ ] Dataset loaded
- [ ] Demo questions tested
- [ ] Backup screenshots
- [ ] Backup video if permitted/needed
- [ ] Live-demo setup tested

## Submission

- [ ] Entry profile complete
- [ ] Idea submitted
- [ ] Correct challenge selected in the portal
- [ ] Public GitHub repository link provided
- [ ] Deployed prototype link provided
- [ ] GitHub link tested in an incognito browser
- [ ] Prototype link tested in an incognito browser
- [ ] Presentation uploaded through its designated module
- [ ] All required fields verified
- [ ] Submit before **4 October 2026, 11:59 PM IST**

---

# 50. Official Prize Structure

According to the official Terms & Conditions:

| Award       |                          Prize |
| ----------- | -----------------------------: |
| 1st Prize   |                     USD $4,300 |
| 2nd Prize   |                     USD $2,200 |
| 3rd Prize   |                     USD $1,590 |
| Consolation | USD $530 each, up to 5 winners |

The event page presents approximate INR equivalents:

| Award         | Approx. INR |
| ------------- | ----------: |
| Winner        |   ₹4,00,000 |
| 1st Runner-up |   ₹2,00,000 |
| 2nd Runner-up |   ₹1,50,000 |
| Consolation   |     ₹50,000 |

Prize payment is subject to eligibility verification, applicable tax/legal requirements, and the official payment rules.

---

# 51. Important Legal/Contest Notes

The official Terms & Conditions state that:

- The contest is skill-based.
- No purchase/payment is necessary.
- Judges' decisions are final and binding under the contest rules.
- The sponsor/administrator may modify, suspend, postpone, or update contest arrangements subject to the official rules.
- Late or incomplete entries are invalid.
- Participants are responsible for accurate contact information.
- Participants must comply with applicable laws and employer policies.
- Sponsor/administrator may verify eligibility.
- Prize recipients may need government ID, bank information and tax information.
- Prize may be forfeited if required verification/documentation is not completed.
- Participants grant specified rights to the sponsor/administrator for submitted entries.
- Sponsor IP/trademarks cannot be used as if they belong to the participant.
- Participants must not use confidential/proprietary information without rights.
- Tampering, automated entry methods, unethical conduct, or rule violations can result in disqualification.

---

# 52. Official Sources

## GCC Edition Event Page

Hack2Skill:

https://hack2skill.com/event/cococlihack-gccedition/

## Official Terms & Conditions

Snowflake CoCo CLI Hackathon GCC Terms & Conditions:

https://docs.google.com/document/d/e/2PACX-1vTrXSK6v7T9tP3-Ab8LuFCDOuuW90debariK5I3PsIF0TrQ4A6q5RSC2B2wA4WM7Qif16AgynvdA4XL/pub

---

# 53. Agent Instruction — Source of Truth

When this file is used by GitHub Copilot, CoCo CLI, or another coding agent:

```text
COMPETITION_CONTEXT.md
        ↓
Primary competition context
        ↓
SPEC.md
        ↓
Technical implementation specification
        ↓
Source code
```

If an implementation decision conflicts with the competition rules:

```text
Competition rules win.
```

If a feature is not required and does not improve:

- real-world relevance,
- technical execution,
- solution completeness,
- or demo clarity,

do not prioritize it before the MVP is stable.

---

# 54. Final Engineering Objective

The final system should prove this statement:

> **We built a real enterprise AI application on Snowflake, using CoCo CLI, that solves the selected business problem end-to-end and provides reliable, explainable results rather than generic AI responses.**

For our selected problem:

```text
Supply Chain Ontology
        +
Governed Semantic Views
        +
Natural Language
        +
Snowflake
        +
CoCo CLI
        +
AI Reasoning
        +
Evidence
        =
SupplyGraph AI
```

---

## End of Competition Context
