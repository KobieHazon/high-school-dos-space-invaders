.PHONY: check stage

check:
	uv run --no-project python scripts/check_repository.py

stage: check
	uv run --no-project python scripts/stage_dos.py
