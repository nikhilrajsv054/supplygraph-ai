# SupplyGraph AI Deployment and Submission

Deadline: **4 October 2026, 11:59 PM IST**.

## 1. Publish the source with GitHub's website

1. Sign in to GitHub and open `https://github.com/new`.
2. Name the public repository `supplygraph-ai`.
3. Do not add a README, `.gitignore`, or license during repository creation.
4. Choose **uploading an existing file** on the empty repository page.
5. Open `SupplyGraph_AI_GitHub_Upload` in File Explorer, select its contents,
   and drag them onto the GitHub upload page. The repository root must contain
   `Dockerfile`, `render.yaml`, `backend`, and `frontend`.
6. Commit the upload through the GitHub page.
7. Confirm that `.env`, `.venv`, `node_modules`, and `.git` are absent.

## 2. Deploy the Render blueprint

1. Sign in to Render and choose **New > Blueprint**.
2. Connect the public `supplygraph-ai` repository.
3. Render detects `render.yaml`; create the `supplygraph-ai` web service.
4. Enter these secret environment variables only in Render:
   - `SNOWFLAKE_ACCOUNT`
   - `SNOWFLAKE_USER`
   - `SNOWFLAKE_PASSWORD`
5. Confirm `SNOWFLAKE_ROLE` is `SUPPLYGRAPH_APP` and
   `CORTEX_MODEL` is `llama3.1-70b`.
6. Deploy and wait for the health check at `/api/health` to pass.

Never paste Snowflake credentials into GitHub, source files, screenshots, the
presentation, or the submission form.

## 3. Smoke-test the public service

Replace `<service-url>` with the URL shown by Render.

1. Open `<service-url>/api/health` and confirm `status` is `ok` and
   `snowflake_configured` is `true`.
2. Open `<service-url>/api/dashboard/summary` and confirm JSON is returned.
3. Open `<service-url>` and wait for **Live governed data**.
4. Ask: `How reliably did vendors honor their commitments in the latest month?`
5. Confirm **Cortex interpreted**, **September 2026**, and **56.91%**.
6. Check the desktop and mobile layouts.

The free Render service can sleep when idle. Open the health endpoint several
minutes before judging or recording the demo so both Render and Snowflake are
warm.

## 4. Final submission package

Submit or retain these items:

- Public GitHub repository URL
- Public Render application URL
- `submission-assets/SupplyGraph_AI_Submission_Deck.pptx`
- Three-to-five-minute demonstration video as a backup
- Team leader name, team size, and eligibility confirmation
- Final submission confirmation or receipt

Before uploading the deck, replace all participant placeholders and add the
final repository and application URLs. Run the questions in `DEMO_SCRIPT.md`
immediately before recording.