NPM_MOD_DIR := $(CURDIR)/node_modules
NPM_BIN_DIR := $(NPM_MOD_DIR)/.bin

SRC_DIR := $(CURDIR)/src
DIST_DIR := $(CURDIR)/dist
PUBLIC_DIR := $(CURDIR)/public

####################################
# Self-documentize utility
####################################
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

####################################
# Bootstrap
####################################
.PHONY: init
init: ## Install dependencies.
	yarn

####################################
# Clean
####################################
.PHONY: clean
clean: clean_dist ## Clean up before building the code.

.PHONY: clean_dist
clean_dist:
	$(NPM_BIN_DIR)/rimraf $(DIST_DIR)/*.*

####################################
# Build
####################################
.PHONY: build
build: ENV ?= dev ## Building scripts and stylesheets.
build:
ifeq ($(ENV),prd)
	$(MAKE) _build RELEASE_CHANNEL=production
else
	$(MAKE) _build RELEASE_CHANNEL=development
endif

.PHONY: _build
_build: clean build_markdown

.PHONY: build_markdown
build_markdown:
	$(NPM_BIN_DIR)/markdown-include tools/markdown-include.json

####################################
# Preview server
####################################
.PHONY: serve
serve: serve_with_nuxt ## Launch preview server with nuxt.

.PHONY: serve_with_nuxt
serve_with_nuxt:
	$(NPM_BIN_DIR)/nuxt