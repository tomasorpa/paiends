#!/usr/bin/env bash
# Paiends — sets up labels, milestones and the first tickets (M0 and M1) on GitHub.
# Run INSIDE the cloned repo folder, with `gh` authenticated.
set -euo pipefail

echo "Repo: $(gh repo view --json nameWithOwner -q .nameWithOwner)"

# ---------- 1. Labels ----------
gh label create backend    --color 1D76DB --description "API, models, business logic" --force
gh label create frontend   --color 5319E7 --description "React, screens, styling" --force
gh label create operations --color FBCA04 --description "Repo, deploy, infrastructure" --force
gh label create learning   --color 0E8A16 --description "Learning something new (tutorials, docs)" --force
gh label create docs       --color C5DEF5 --description "Documentation, ADRs, devlog" --force
gh label create product    --color D93F0B --description "Product decisions and game rules" --force

# ---------- 2. Milestones (Christmas plan) ----------
create_milestone () {
  gh api "repos/{owner}/{repo}/milestones" -f title="$1" -f due_on="$2" -f description="$3" >/dev/null
  echo "Milestone created: $1"
}
create_milestone "M0 · Foundations"          "2026-11-22T23:59:59Z" "Repo, FastAPI, /health on Render, database on Neon"
create_milestone "M1 · Rules engine"         "2026-11-29T23:59:59Z" "Scoring rules as pure functions, fully tested"
create_milestone "M2 · API and database"     "2026-12-06T23:59:59Z" "Models, migrations and workout endpoints"
create_milestone "M3 · Ranking and users"    "2026-12-13T23:59:59Z" "Weekly ranking, 4 users, access via personal link or PIN"
create_milestone "M4 · Frontend"             "2026-12-20T23:59:59Z" "Ranking and Log workout screens wired to the API"
create_milestone "M5 · Week close and payments" "2026-12-27T23:59:59Z" "Close the week, payments and fines, first real week with friends"

# ---------- 3. Tickets ----------
issue () {  # $1 title, $2 labels, $3 milestone, body from stdin
  gh issue create --title "$1" --label "$2" --milestone "$3" --body-file -
}

issue "Repo structure and README" "operations,docs" "M0 · Foundations" <<'EOF'
## Goal
Get the repo ready to tell the story of the build. ⏱ 30 min

## Tasks
- [ ] Folders `backend/`, `frontend/`, `docs/adr/`, `docs/devlog/`
- [ ] `.gitignore` for Python and Node
- [ ] README: what Paiends is, stack, roadmap (milestones) and "Live demo: coming soon"
- [ ] Ticket template in `.github/ISSUE_TEMPLATE/ticket.md`

## Done when
The README renders well on GitHub and the structure is on `main`.
EOF

issue "Install Python 3.12 + uv and scaffold the backend" "backend,learning" "M0 · Foundations" <<'EOF'
## Goal
A reproducible Python environment for the backend. ⏱ 45 min

## Tasks
- [ ] Install `uv` (package and environment manager)
- [ ] Run `uv init` inside `backend/`
- [ ] `uv add fastapi uvicorn`
- [ ] Note in the devlog what `pyproject.toml` and `uv.lock` are for

## Done when
`uv run python --version` prints 3.12 and the dependencies are listed in `pyproject.toml`.
EOF

issue "Official FastAPI tutorial: First Steps and Path Parameters" "learning" "M0 · Foundations" <<'EOF'
## Goal
Learn the FastAPI basics by typing them out, no copy-paste. ⏱ 60 min

## Tasks
- [ ] Follow "First Steps" in the official tutorial
- [ ] Follow "Path Parameters"
- [ ] Try the endpoints in `/docs`
- [ ] Write down 3 things you learned in the devlog

## Done when
You can explain in your own words what `@app.get` does and what `/docs` is.
EOF

issue "GET /health endpoint" "backend" "M0 · Foundations" <<'EOF'
## Goal
The app's first real endpoint. ⏱ 30 min

## Tasks
- [ ] `backend/app/main.py` with `GET /health` returning `{"status": "ok"}`
- [ ] Run it with `uv run uvicorn app.main:app --reload`
- [ ] Check it in `/docs`

## Done when
`curl localhost:8000/health` returns `{"status":"ok"}`.
EOF

issue "Deploy /health to Render" "operations" "M0 · Foundations" <<'EOF'
## Goal
A public URL from week 1. ⏱ 45 min

## Tasks
- [ ] Render account connected to GitHub
- [ ] Web Service (Free plan) with root directory `backend`
- [ ] Start command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
- [ ] Add the URL to the README

## Done when
`https://<your-service>.onrender.com/health` returns `{"status":"ok"}`.
EOF

issue "Create the Neon database and wire up DATABASE_URL" "operations" "M0 · Foundations" <<'EOF'
## Goal
Postgres ready for M2. ⏱ 30 min

## Tasks
- [ ] Neon project (Free plan)
- [ ] Copy the connection string
- [ ] Store it as `DATABASE_URL` in Render (Environment) and in a local `.env`
- [ ] Confirm `.env` is in `.gitignore`

## Done when
`DATABASE_URL` exists on Render and locally, and never appears in the repo.
EOF

issue "Resolve open rule questions before building the engine" "product" "M1 · Rules engine" <<'EOF'
## Goal
Make the product-owner calls on ambiguous rules. ⏱ 30 min

## Questions
- [ ] Tie on points: who pays less?
- [ ] MMA "from the 3rd consecutive class": consecutive days, or within the same week?
- [ ] Missing the minimum sessions: is the fine added on top of the placement payment?
- [ ] "Other" needs 3 approvals: how many rejections void it? (no validation in December; decide for January)
- [ ] $15 pot minimum: what happens if payments add up to less?

## Done when
The answers are recorded in `docs/adr/003-rules.md`.
EOF

issue "Write ARCHITECTURE.md in my own words" "docs" "M1 · Rules engine" <<'EOF'
## Goal
Explain the architecture as if you were walking an interviewer through it. ⏱ 45 min

## Tasks
- [ ] Stack: FastAPI, Postgres (Neon), Render, Vercel
- [ ] Modules: rules engine, workouts, weeks and close, payments
- [ ] Key decisions: money in cents, points as Decimal, frozen weekly snapshot
- [ ] ADR 001 (FastAPI) and ADR 002 (free hosting stack)

## Done when
`docs/ARCHITECTURE.md` and two ADRs are on `main`.
EOF

echo "Done. Check with: gh issue list"
