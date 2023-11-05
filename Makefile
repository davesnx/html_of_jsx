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
	opam switch create . 5.1.0 --deps-only --with-test -y

.PHONY: install
install: # Install dependencies
	opam install . --deps-only --with-test --with-doc

.PHONY: init
init: setup-githooks create-switch install ## Create a local dev enviroment

.PHONY: demo
demo: ## Run demo executable
	$(DUNE) exec demo/server.exe

.PHONY: demo-watch
demo-watch: ## Run demo executable
	$(DUNE) exec -w demo/server.exe

.PHONY: subst
subst: ## Run dune substitute
	$(DUNE) subst

.PHONY: documentation
documentation: ## Generate odoc documentation
	$(DUNE) build --root . @doc

.PHONY: documentation-watch
documentation-watch: ## Generate odoc documentation
	$(DUNE) build --root . -w @doc

.PHONY: documentation-serve
documentation-serve: ## Open odoc documentation with default web browser
	open _build/default/_doc/_html/index.html
