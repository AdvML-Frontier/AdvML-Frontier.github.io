PYTHON ?= python3
NODE ?= node
HOST ?= 127.0.0.1
START_PORT ?= 8000
SITE_DIR := satml2027
SITE_PATH := /satml2027

# Select the first free port at or above START_PORT unless PORT is explicit.
AUTO_PORT = $(shell $(PYTHON) scripts/find_free_port.py --host "$(HOST)" --start "$(START_PORT)")
PORT ?= $(AUTO_PORT)

.DEFAULT_GOAL := help

.PHONY: help list serve preview _serve port routes check check-tools check-html check-css check-js check-routes check-diff status

help:
	@printf '%s\n' \
		'AdvML-Frontiers website commands' \
		'' \
		'  make                    Show this command list' \
		'  make serve              Serve the site on an automatically selected free port' \
		'  make preview            Serve on a free port and open /satml2027 in a browser' \
		'  make serve PORT=8000    Serve on an explicitly selected port' \
		'  make port               Print the next automatically selected free port' \
		'  make routes             List the public routes' \
		'  make check              Run all local site checks' \
		'  make check-html         Check duplicate IDs and missing local files' \
		'  make check-css          Check stylesheet structure' \
		'  make check-js           Check JavaScript syntax' \
		'  make check-routes       Check for obsolete or index.html URLs' \
		'  make check-diff         Check Git diffs for whitespace errors' \
		'  make status             Show the branch and working-tree status' \
		'' \
		'Optional variables: HOST=127.0.0.1  START_PORT=8000  PORT=<exact port>  PYTHON=python3  NODE=node'

list: help

serve: OPEN_BROWSER := 0
serve: _serve

preview: OPEN_BROWSER := 1
preview: _serve

_serve:
	@port="$(PORT)"; \
	if [ -z "$$port" ]; then \
		echo 'Could not find a free port. Set one explicitly with PORT=<number>.' >&2; \
		exit 1; \
	fi; \
	root_url="http://$(HOST):$$port/"; \
	event_url="http://$(HOST):$$port$(SITE_PATH)"; \
	printf '\nServing AdvML-Frontiers\n  Root:       %s\n  SaTML 2027: %s\n\nPress Ctrl-C to stop.\n\n' "$$root_url" "$$event_url"; \
	if [ "$(OPEN_BROWSER)" = '1' ]; then \
		if command -v open >/dev/null 2>&1; then \
			(sleep 0.5; open "$$event_url") >/dev/null 2>&1 & \
		elif command -v xdg-open >/dev/null 2>&1; then \
			(sleep 0.5; xdg-open "$$event_url") >/dev/null 2>&1 & \
		else \
			echo "No browser opener found; open $$event_url manually."; \
		fi; \
	fi; \
	exec $(PYTHON) -m http.server "$$port" --bind "$(HOST)"

port:
	@$(PYTHON) scripts/find_free_port.py --host "$(HOST)" --start "$(START_PORT)"

routes:
	@printf '%s\n' \
		'Public routes' \
		'  /             Current AdvML-Frontiers site' \
		'  /satml2027    SaTML 2027 event page (served from its directory index)'

check: check-tools check-html check-css check-js check-routes check-diff
	@printf '\nAll checks passed.\n'

check-tools:
	@$(PYTHON) scripts/find_free_port.py --help >/dev/null
	@echo 'Development tooling: OK'

check-html:
	@$(NODE) -e 'const fs=require("fs"),path=require("path"),base="$(SITE_DIR)",html=fs.readFileSync(path.join(base,"index.html"),"utf8"); const ids=[...html.matchAll(/\sid="([^"]+)"/g)].map(match=>match[1]); const duplicates=[...new Set(ids.filter((id,index)=>ids.indexOf(id)!==index))]; const refs=[...html.matchAll(/\s(?:href|src)="([^"]+)"/g)].map(match=>match[1]).filter(ref=>!ref.startsWith("http")&&!ref.startsWith("mailto:")&&!ref.startsWith("#")&&!ref.startsWith("/")); const missing=[...new Set(refs.filter(ref=>!fs.existsSync(path.resolve(base,ref.split("#")[0].split("?")[0]))))]; if(duplicates.length||missing.length){if(duplicates.length)console.error("Duplicate IDs:",duplicates.join(", "));if(missing.length)console.error("Missing local files:",missing.join(", "));process.exit(1)} console.log("HTML references and IDs: OK")'

check-css:
	@$(NODE) -e 'const fs=require("fs"),css=fs.readFileSync("$(SITE_DIR)/css/style.css","utf8"),delta=(css.match(/{/g)||[]).length-(css.match(/}/g)||[]).length; if(delta){console.error("Unbalanced CSS braces:",delta);process.exit(1)} console.log("CSS structure: OK")'

check-js:
	@$(NODE) --check "$(SITE_DIR)/js/main.js"
	@echo 'JavaScript syntax: OK'

check-routes:
	@if rg -n '/satml27|/satml2027/index\.html' "$(SITE_DIR)"; then \
		echo 'Obsolete or non-canonical routes found.' >&2; \
		exit 1; \
	else \
		echo 'Clean routes: OK'; \
	fi

check-diff:
	@git diff --check
	@git diff --cached --check
	@echo 'Git diff whitespace: OK'

status:
	@git status --short --branch
