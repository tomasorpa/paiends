# Paiends

**A weekly fitness challenge for groups of friends: train, earn points, climb the ranking, and pay up if you slack off.**

> 🚧 **Live demo: coming soon** · Work in progress — follow the build on the [project board](#project-management).

---

## The problem

Staying consistent with training is easier when friends hold you accountable, and even easier when there's a little money on the line.

Running that kind of challenge by hand doesn't scale. Someone has to collect every workout, apply the scoring rules, settle ties, work out who owes what each week, and remember who still hasn't paid. Rules get bent, numbers get disputed, and the person keeping score burns out.

## The solution

Paiends does the bookkeeping so the group can focus on training:

1. **Log a workout:** run, gym, MMA, football, climbing, cycling, stretching or other.
2. **Get points automatically:** each discipline has its own rules (pace, sets, minutes, distance), computed on the server so nobody can fudge them.
3. **Check the weekly ranking:** see where everyone stands in real time.
4. **Close the week:** the ranking is frozen, payouts to the pot are assigned by placement, and anyone who missed the minimum number of sessions gets a fine.
5. **Track payments:** see who owes what and mark it as paid.

## Tech stack

| Layer | Technology | Hosting (free tier) |
|---|---|---|
| Backend | Python 3.12, FastAPI, SQLAlchemy 2.0, Alembic, pytest | Render |
| Database | PostgreSQL | Neon |
| Frontend | React, Vite, TypeScript | Vercel |
| Scheduled jobs | GitHub Actions | GitHub |
| Tooling | uv, GitHub Issues + Projects | — |

### Key design decisions

- **Rules engine as pure functions:** scoring logic has no database or HTTP dependencies, so it is fully unit-tested.
- **Money stored in integer cents, points as `Decimal`:** no floating-point rounding errors.
- **Frozen weekly snapshots:** closing a week stores its results, so changing a rule later never rewrites past weeks.
- **Multi-group ready:** the MVP runs one group, but the data model supports many from day one.

More detail in [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) and the decision records in [`docs/adr/`](docs/adr/).

## Roadmap

The first goal is a version my friends and I can use every week by Christmas 2026.

| Milestone | Scope | Target |
|---|---|---|
| **M0 · Foundations** | Repo, FastAPI, `/health` deployed on Render, database on Neon | Nov 22 |
| **M1 · Rules engine** | Scoring rules as pure functions, fully tested | Nov 29 |
| **M2 · API and database** | Models, migrations, workout endpoints | Dec 6 |
| **M3 · Ranking and users** | Weekly ranking, group members, simple access | Dec 13 |
| **M4 · Frontend** | Ranking and Log workout screens wired to the API | Dec 20 |
| **M5 · Week close and payments** | Close the week, payouts and fines, first real week | Dec 27 |

**Next (v1.0, January 2027):** full authentication, peer validation of workouts, automatic weekly close, group stats, analytics and a public demo account.

## Project management

Every task is a GitHub issue with a clear goal and a "done when" checklist, grouped into weekly milestones and tracked on a board. Each one ships through its own branch and pull request.

- 📋 [Issues](../../issues)
- 🗂️ [Milestones](../../milestones)
- 📓 [Devlog](docs/devlog/): weekly notes on what I built and learned

## Running locally

_Coming in M0._

## Author

Built in public, 30–60 minutes a day, as a way to learn FastAPI from scratch.