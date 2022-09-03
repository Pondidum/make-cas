.SHELLFLAGS := -eu -c
.ONESHELL:			# all things in a rule run in one shell, rather than shell per line
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: build
build: dist/index.js

dist/index.js: $(shell ./build/cas.sh $(shell find src -iname "*.ts" -not -iname "*.test.ts"))
	@echo "==> Building"
	@sleep 3s
	@mkdir -p "dist"
	@echo "compiled at $(shell date)" > "$@"
	@echo "==> Done"

	@./build/artifact.sh "$<" "$@"


.PHONY: test
test: artifacts/test-report.json

artifacts/test-report.json: $(shell ./build/cas.sh $(shell find src -iname "*.ts"))
	@echo "==> Running Tests"
	@sleep 1s
	@mkdir -p artifacts/
	@echo '{"tests": 10, "lastRun": "$(shell date)"}' > "$@"
	@echo '{}' > "artifacts/coverage.json"
	@echo "==> Passed"

	@./build/artifact.sh "$<" "$@"
	@./build/artifact.sh "$<" "artifacts/coverage.json"
