# Contributing to Pulse

A FastAPI + DuckDB prototype of a next-best-action engine for wealth RMs. Server-rendered Jinja pages,
no JS build step. Run with `./run.sh` (or `uvicorn app.main:app --reload`).

## Where things live
- `app/signals/*.sql` — one signal per file. Contract: return `client_id, impact_inr, urgency, deadline_on` + evidence columns.
- `app/engine.py` — `CATALOG` (title, family, prior, headline template, client-app copy) and `MATH` (plain-English rules). `materialise_signals()` scores rows into the `signals` table.
- `app/analytics.py` — the "what's broken" queries behind Book health.
- `app/ai.py` — the Claude call brief (structured output) and the NL→SQL agent (`run_sql` tool, `guard_sql`).
- `scripts/generate_data.py` — deterministic synthetic book; stories are planted via `flags` in `make_clients()`.

## Adding a signal
1. Write `app/signals/<name>.sql` following the contract (use `as_of()`, `v_client_aum`, `v_last_contact`).
2. Add an entry to `CATALOG` and `MATH` in `app/engine.py`.
3. Run `python scripts/build_signal_docs.py` to refresh `docs/SIGNALS.md`.
4. If the story needs planting, add a flag to the generator and regenerate the book.

## Conventions
- Money is INR floats in the DB; format with `app/fmt.py`'s `inr()` in Python and `Pulse.inr()` in JS.
- `as_of()` (from the `meta` table) is "today" everywhere — never `current_date`.
- Keep SQL readable: it's a deliverable, not just plumbing.
