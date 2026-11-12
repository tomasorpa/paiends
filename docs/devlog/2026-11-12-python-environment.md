# 2026-11-12 · Reproducible Python environment for the backend

## What I did

- Installed **uv** (0.12.9), which manages both packages and virtual environments.
- Ran `uv init --python 3.12` inside `backend/`. This created `pyproject.toml`, `.python-version`, a `src/paiends_backend/` package and a `.venv/`.
- Ran `uv add fastapi uvicorn`. This installed both packages into `.venv/`, recorded them in `pyproject.toml` and wrote `uv.lock`.
- Checked it: `uv run python --version` prints `Python 3.12.10`.

## What each file is for

### `pyproject.toml`: what the project needs

This is the project's manifest, the standard Python config file (PEP 621). It lists:

- the project name, version and description;
- `requires-python = ">=3.12"`;
- the **direct dependencies** with minimum versions (`fastapi>=…`, `uvicorn>=…`).

It records *intent*: which packages I chose and the version ranges I accept. I edit it by hand or with `uv add` / `uv remove`. It is committed to git.

### `uv.lock`: exactly what gets installed

This is the lockfile, and uv generates it, so I don't edit it by hand. It pins **every** package in the dependency tree (direct and transitive, such as `starlette`, `pydantic` and `anyio`) to an exact version and file hash, for every platform.

It records *reality*. Anyone who runs `uv sync` gets the same environment I have, on Windows, macOS, Linux or Render. That makes the setup reproducible: no "works on my machine". It is committed to git too.

### `.python-version`: which interpreter to use

Contains `3.12`. uv reads it to choose (or download) the Python version for `.venv/`.

### `.venv/`: the actual environment

The installed packages live here. It is disposable: `uv sync` rebuilds it from `uv.lock`. It is git-ignored.

## Takeaway

`pyproject.toml` lists what I asked for, and `uv.lock` records exactly what was installed. Commit both. Never commit `.venv/`. Use `uv run <cmd>` so commands always run inside the locked environment.
