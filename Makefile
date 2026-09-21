.PHONY: check stage

check: test

stage:
	uv run --no-project python scripts/stage_dos.py

.PHONY: test
test:
	docker build -f docker/Dockerfile -t dos-space-invaders-tests .
	docker run --rm --network none --security-opt no-new-privileges -v "$(CURDIR):/project:ro" dos-space-invaders-tests timeout 40 xvfb-run -a python3 /project/scripts/test_dos.py
