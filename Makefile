project_name = html_of_jsx

DUNE = opam exec -- dune
opam_file = $(project_name).opam

.PHONY: help
help: ## Print this help message
	@echo "";
	@echo "List of available make commands";
	@echo "";
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}';
	@echo "";

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	$(DUNE) build @all

.PHONY: build-prod
build-prod: ## Build for production (--profile=prod)
	$(DUNE) build --profile=prod @all

.PHONY: bench
bench: ## Run benchmarks (human-readable output)
	$(DUNE) exec bench/bench.exe

.PHONY: bench-ci
bench-ci: ## Run benchmarks with JSON output for CI mostly
	$(DUNE) exec bench/bench.exe -- --json > bench_results.json

.PHONY: bench-compare
bench-compare: ## Compare with baseline (outputs latency diff)
	@if [ ! -f bench/results/baseline.json ]; then \
		echo "No baseline found. Run 'make bench-baseline' first."; \
		exit 1; \
	fi
	$(DUNE) exec bench/bench.exe -- --compare bench/results/baseline.json

.PHONY: bench-baseline
bench-baseline: ## Save current results as new baseline
	$(DUNE) exec bench/bench.exe -- --json > bench/results/baseline.json
	@echo "Baseline saved to bench/results/baseline.json"

.PHONY: bench-memory
bench-memory: ## Run memory allocation benchmarks
	$(DUNE) exec bench/memory.exe

.PHONY: dev
dev: ## Build in watch mode
	$(DUNE) build -w @all

.PHONY: clean
clean: ## Clean artifacts
	$(DUNE) clean

.PHONY: test
test: ## Run the tests
	$(DUNE) build @runtest

.PHONY: test-watch
test-watch: ## Run the tests in watch mode
	$(DUNE) build @runtest -w

.PHONY: test-promote
test-promote: ## Updates snapshots and promotes it to correct
	$(DUNE) build @runtest --auto-promote

.PHONY: format
format: ## Format the codebase with ocamlformat
	$(DUNE) build @fmt --auto-promote

.PHONY: format-check
format-check: ## Checks if format is correct
	$(DUNE) build @fmt

.PHONY: init
setup-githooks: ## Setup githooks
	git config core.hooksPath .githooks

.PHONY: create-switch
create-switch: ## Create opam switch
	opam switch create . 5.4.0 --deps-only --with-test --no-install -y

.PHONY: install
install: # Install dependencies
	opam install . --deps-only --with-test --with-doc --with-dev-setup -y

.PHONY: pin
pin: # pin dependencies
	opam pin add mlx.dev "https://github.com/ocaml-mlx/mlx.git#3d314aa8e7793b38150ebf25b2fe017778c714a5" -y
	opam pin add ocamlmerlin-mlx.dev "https://github.com/ocaml-mlx/mlx.git#3d314aa8e7793b38150ebf25b2fe017778c714a5" -y
	opam pin add ocamlformat-mlx-lib.dev "https://github.com/ocaml-mlx/ocamlformat-mlx.git#d3b159056eb65f9b76293389ba8e3c4b97031a42" -y
	opam pin add ocamlformat-mlx.dev "https://github.com/ocaml-mlx/ocamlformat-mlx.git#d3b159056eb65f9b76293389ba8e3c4b97031a42" -y
	opam pin add jsonrpc.dev "https://github.com/davesnx/ocaml-lsp.git#687d9f21af1256ba6c16bf851e597c9a292c75ed" -y
	opam pin add lsp.dev "https://github.com/davesnx/ocaml-lsp.git#687d9f21af1256ba6c16bf851e597c9a292c75ed" -y
	opam pin add ocaml-lsp-server.dev "https://github.com/davesnx/ocaml-lsp.git#687d9f21af1256ba6c16bf851e597c9a292c75ed" -y

.PHONY: init
init: setup-githooks create-switch pin install ## Create a local dev enviroment

.PHONY: demo
demo: ## Run demo executable
	$(DUNE) exec demo/server.exe

.PHONY: demo-watch
demo-watch: ## Run demo executable
	$(DUNE) exec -w demo/server.exe

.PHONY: demo-client
demo-client: build ## Run client's demo
	node _build/default/demo/output/demo/client.mjs

.PHONY: subst
subst: ## Run dune substitute
	$(DUNE) subst

.PHONY: docs
docs: ## Generate odoc docs
	$(DUNE) build --root . @doc

.PHONY: docs-watch
docs-watch: ## Generate odoc docs
	$(DUNE) build --root . -w @doc

.PHONY: docs-serve
docs-serve: ## Open odoc docs with default web browser
	open _build/default/_doc/_html/index.html

.PHONY: release
release: ## Create and push a release tag (usage: make release VERSION=1.0.0)
	@if [ -z "$(VERSION)" ]; then \
		echo "Error: VERSION is required"; \
		echo "Usage: make release VERSION=1.0.0"; \
		exit 1; \
	fi
	@.github/scripts/create-release.sh $(VERSION)
