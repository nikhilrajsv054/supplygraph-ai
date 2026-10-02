# SupplyGraph AI Submission Checklist

Deadline: **4 October 2026, 11:59 PM IST**.

## Functional

- [x] Snowflake database and warehouse created
- [x] Synthetic data loaded
- [x] Canonical ontology implemented
- [x] Governed entity and metric views implemented
- [x] Formal semantic view implemented
- [x] FastAPI connected to Snowflake
- [x] Dashboard uses live governed data
- [x] Supported conversational questions work
- [x] Evidence and SQL are displayed
- [x] Persona metric consistency is tested
- [x] Demo fallback is visibly labeled

## Engineering

- [x] Root README and setup instructions
- [x] Architecture and trust boundary documented
- [x] Backend tests: 12 passing
- [x] Frontend lint and production build passing
- [x] Live Playwright integration test passing
- [x] Dockerfile and Compose configuration included
- [x] Render deployment blueprint included
- [x] `.env` excluded from source control and Docker context
- [x] Public errors do not expose Snowflake details
- [x] Read-only `SUPPLYGRAPH_APP` runtime role verified with Cortex
- [ ] Build and smoke-test Docker image (local Rancher WSL backend unavailable)

## Demo Assets

- [x] 3–5 minute demo script prepared
- [x] Official PowerPoint template present
- [x] Add team leader name and team size to generated presentation deck
- [x] Populate presentation content and visually validate all slides
- [x] Capture final desktop, mobile, and governed-evidence screenshots
- [ ] Record backup demonstration video
- [ ] Test all demo questions immediately before recording

## Repository and Deployment

- [x] Prepare clean browser-upload directory without local Git
- [x] Scan upload directory for secrets and excluded runtime files
- [x] Document GitHub and Render browser deployment steps
- [ ] Create public GitHub repository
- [ ] Upload clean source and documentation through GitHub UI
- [ ] Deploy Docker service
- [ ] Configure Snowflake secrets in hosting platform
- [ ] Verify public health, dashboard, and chat endpoints
- [ ] Add public repository and demo URLs to presentation

## Hackathon Submission

- [x] GCC supply-chain ontology problem selected
- [x] Snowflake usage is central to the implementation
- [x] CoCo CLI usage documented in README
- [ ] Confirm participant/team details and eligibility
- [ ] Complete official submission form
- [ ] Upload final presentation deck
- [ ] Add repository URL
- [ ] Add demo URL or video if requested
- [ ] Perform final English-language and confidentiality review
- [ ] Submit before the deadline and retain confirmation
