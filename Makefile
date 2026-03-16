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
	opam update
	opam install . --deps-only --with-test --with-doc --with-dev-setup -y

.PHONY: pin
pin: # pin dependencies
	opam pin add dune "https://github.com/ocaml/dune.git#f000f24921f80c1c0ff86c4747c7a45f4ac43163" -y -n
	opam pin add ochre "https://github.com/davesnx/ochre.git#7cfd98dfd52f5e1942cd1a7e1fbcc8e2cc6322e1" -y -n
	opam pin add textmate-language "https://github.com/davesnx/ocaml-textmate-language.git#3fed1834182f9392bd310aee686555615ab85991" -y -n
	opam pin add tm-grammars "https://github.com/davesnx/tm-grammars.git#7bc690111b6d6a9c6896bc35aa17bfb854c33a2d" -y -n

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

.PHONY: docs-api
docs-api: docs-content ## Backward-compatible alias for docs markdown sync

.PHONY: docs-content
docs-content: ## Generate markdown docs and promote to docs/content
	$(DUNE) build --root . @doc-markdown @docs-content --auto-promote

.PHONY: docs-site-deps
docs-site-deps: ## Install docs site dependencies in local switch
	opam install yocaml yocaml_unix ochre tm-grammars omd -y

.PHONY: docs-site
docs-site: docs-content ## Build Yocaml docs site into docs/_site
	DOCS_SITE=true $(DUNE) exec --root . ./site/build_site.exe

.PHONY: docs-site-serve
docs-site-serve: docs-site ## Serve generated docs site locally on :8080
	python3 -m http.server 8080 --directory docs/_site

.PHONY: docs-watch
docs-watch: ## Generate odoc docs in watch mode
	$(DUNE) build --root . -w @doc

.PHONY: docs-serve
docs-serve: docs ## Serve odoc docs locally on :8080
	python3 -m http.server 8080 --directory _build/default/_doc/_html

.PHONY: release
release: ## Create and push a release tag (usage: make release VERSION=1.0.0)
	@if [ -z "$(VERSION)" ]; then \
		echo "Error: VERSION is required"; \
		echo "Usage: make release VERSION=1.0.0"; \
		exit 1; \
	fi
	@.github/scripts/create-release.sh $(VERSION)
