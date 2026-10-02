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

## 2. Deploy the FastAPI backend on Vercel

1. Import the public `supplygraph-ai` repository into Vercel.
2. Choose the detected `backend` FastAPI application as a single project.
3. Set the project name to `supplygraph-ai` and root directory to `backend`.
4. Enter these secret environment variables only in Vercel:
   - `SNOWFLAKE_ACCOUNT`
   - `SNOWFLAKE_USER`
   - `SNOWFLAKE_PASSWORD`
5. Confirm `SNOWFLAKE_ROLE` is `SUPPLYGRAPH_APP` and
   `CORTEX_MODEL` is `llama3.1-70b`.
6. Set `FRONTEND_ORIGINS` to the public frontend origin.
7. Deploy and verify `https://supplygraph-ai.vercel.app/api/health`.

Never paste Snowflake credentials into GitHub, source files, screenshots, the
presentation, or the submission form.

## 3. Deploy the Vite frontend on Vercel

1. Import the same repository as another Vercel project.
2. Choose the detected `frontend` Vite application as a single project.
3. Set the project name to `supplygraph-ai-web` and root directory to `frontend`.
4. Add `VITE_API_URL=https://supplygraph-ai.vercel.app/api`.
5. Deploy and open `https://supplygraph-ai-web.vercel.app`.

## 4. Smoke-test the public service

1. Open `https://supplygraph-ai.vercel.app/api/health` and confirm `status` is `ok` and
   `snowflake_configured` is `true`.
2. Open `https://supplygraph-ai.vercel.app/api/dashboard/summary` and confirm JSON is returned.
3. Open `https://supplygraph-ai-web.vercel.app` and wait for **Live governed data**.
4. Ask: `How reliably did vendors honor their commitments in the latest month?`
5. Confirm **Cortex interpreted**, **September 2026**, and **56.91%**.
6. Check the desktop and mobile layouts.

Open the health endpoint before judging or recording the demo so Vercel and
Snowflake are warm.

## 5. Final submission package

Submit or retain these items:

- Public GitHub repository URL
- Public Vercel application URL
- `submission-assets/SupplyGraph_AI_Submission_Deck.pptx`
- Three-to-five-minute demonstration video as a backup
- Team leader name, team size, and eligibility confirmation
- Final submission confirmation or receipt

Before uploading the deck, replace all participant placeholders and add the
final repository and application URLs. Run the questions in `DEMO_SCRIPT.md`
immediately before recording.