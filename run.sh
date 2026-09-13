#!/usr/bin/env bash
# One-shot local run: venv, deps, data, server.
set -e
cd "$(dirname "$0")"
[ -d .venv ] || python3 -m venv .venv
.venv/bin/pip install -q -r requirements.txt
[ -f data/clients.csv ] || .venv/bin/python scripts/generate_data.py
[ -f .env ] && set -a && . ./.env && set +a
exec .venv/bin/python -m uvicorn app.main:app --reload --port "${PORT:-8000}"
