.DEFAULT_GOAL := project

# Use $(HOME) so paths expand correctly
TEMPLATES_ORIGIN_PATH?=$(HOME)/Library/Developer/Xcode/Templates
TEMPLATES_PATH?=$(TEMPLATES_ORIGIN_PATH)/BonjurFeatureModule.xctemplate
RELEASE_MODE?=false

help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install-templates: uninstall-templates ## install template
	@echo "Installing BonjurFeatureModule template..."
	mkdir -p "$(TEMPLATES_ORIGIN_PATH)"
	# Copy the entire .xctemplate folder, not just its contents
	cp -R Templates/BonjurFeatureModule.xctemplate "$(TEMPLATES_ORIGIN_PATH)/"
	@echo "Xcode template installed successfully!"
	@echo "Restart Xcode to use it."

uninstall-templates: ## uninstall BonjurFeatureModule template
	@echo "Uninstalling BonjurFeatureModule template..."
	@if [ -d "$(TEMPLATES_PATH)" ]; then \
		rm -rf "$(TEMPLATES_PATH)"; \
		echo "Removed: $(TEMPLATES_PATH)"; \
	else \
		echo "Skip (not found): $(TEMPLATES_PATH)"; \
	fi

generate: ## generate the project
	tuist generate --no-open --cache-profile none
	open *.xcw*
	
project: ## generate the project and open Xcode
	tuist generate --no-open --cache-profile none
	open *.xcw*
	
install-project: ## generate the project and open Xcode
	tuist install
	open *.xcw*

edit: ## edit project configuration
	tuist edit
