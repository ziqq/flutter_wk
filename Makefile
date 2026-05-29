SHELL := bash
.SHELLFLAGS := -e -o pipefail -c

ifeq ($(OS),Windows_NT)
HOST_OS := windows
else
UNAME_S := $(shell uname -s 2>/dev/null || echo Unknown)
ifeq ($(UNAME_S),Darwin)
HOST_OS := macos
else ifeq ($(UNAME_S),Linux)
HOST_OS := linux
else
HOST_OS := unknown
endif
endif

ROOT_DIR := $(CURDIR)
IOS_CLEAN_SCRIPT := ./tool/scripts/flutter-clean-ios.sh
TEST_PACKAGES_SCRIPT := ./tool/scripts/test-packages.sh
LOG_PREFIX := [make]
ANALYZE_FLAGS := --fatal-warnings --no-fatal-infos
TEST_FLAGS := --color --coverage --concurrency=50 --platform=tester --reporter=expanded --timeout=30s
FVM := $(shell command -v fvm 2>/dev/null)

ifeq ($(strip $(FVM)),)
DART := dart
FLUTTER := flutter
else
DART := fvm dart
FLUTTER := fvm flutter
endif

define require_macos
	@if [ "$(HOST_OS)" != "macos" ]; then \
		echo "$(LOG_PREFIX) Error: target '$1' is supported only on macOS."; \
		exit 1; \
	fi
endef

.DEFAULT_GOAL := all
.PHONY: all
all: ## build pipeline
all: get format check test-unit

.PHONY: ci
ci: ## CI build pipeline
ci: all

.PHONY: precommit
precommit: ## validate the branch before commit
precommit: all

.PHONY: help
help: ## Help dialog
				@echo 'Usage: make <OPTIONS> ... <TARGETS>'
				@echo ''
				@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: doctor
doctor: ## Check flutter doctor
				@$(FLUTTER) doctor

.PHONY: version
version: ## Check flutter version
				@$(FLUTTER) --version

.PHONY: format
format: ## Format code
				@$(DART) format . --set-exit-if-changed --line-length 80 -o none || (echo "¯\_(ツ)_/¯ Format code error"; exit 1)

.PHONY: fix
fix: format ## Fix code
				@$(DART) fix --apply lib

.PHONY: clean
clean: ## Clean flutter
				@$(FLUTTER) clean
				@cd example && @$(FLUTTER) clean

.PHONY: get
get: ## Get dependencies
				@$(FLUTTER) pub get || (echo "¯\_(ツ)_/¯ Get dependencies error"; exit 1)

.PHONY: init-ios-pods
init-ios-pods: ## Init ios pods (use Podfile)
				@$(FLUTTER) config --no-enable-swift-package-manager && flutter config --no-enable-swift-package-manager
				@cd example && @$(FLUTTER) clean
				@cd example && @$(FLUTTER) pub get
				@cd example/ios && \
						( [ -f "_Podfile" ] && [ ! -f "Podfile" ] && mv "_Podfile" "Podfile" || true ) && \
						rm -rf Pods Podfile.lock && \
						pod install
				@cd example && @$(FLUTTER) pub get || (echo "¯\_(ツ)_/¯ Init ios pods error"; exit 1)

.PHONY: init-ios-spm
init-ios-spm: ## Init ios swift package manager (use _Podfile)
				@$(FLUTTER) config --enable-swift-package-manager && flutter config --enable-swift-package-manager
				@cd example && @$(FLUTTER) clean
				@cd example/ios && \
						( [ -f "Podfile" ] && mv "Podfile" "_Podfile" || true ) && \
						rm -rf Pods Podfile.lock && \
						( pod deintegrate || true )
				@cd example && @$(FLUTTER) pub get || (echo "¯\_(ツ)_/¯ Init ios swift package manager error"; exit 1)

.PHONY: analyze
analyze: get format ## Analyze code
				@$(FLUTTER) analyze --fatal-warnings --no-fatal-infos lib/ test/

.PHONY: check
check: analyze ## Check code
				@$(DART) pub publish --dry-run

.PHONY: publish
publish: ## Publish package
				@$(DART) pub publish --server=https://pub.dartlang.org || (echo "¯\_(ツ)_/¯ Publish error"; exit 1)

.PHONY: coverage
coverage: ## Runs get coverage
				@lcov --summary coverage/lcov.info

.PHONY: run-genhtml
run-genhtml: ## Runs generage coverage html
				@genhtml coverage/lcov.info -o coverage/html

.PHONY: test-unit
test-unit: ## Runs unit tests
				@$(FLUTTER) test --coverage || (echo "Error while running tests"; exit 1)
				@genhtml coverage/lcov.info --output=coverage -o coverage/html || (echo "Error while running genhtml with coverage"; exit 2)

.PHONY: test-dart
test-dart: ## Runs package Dart tests
				$(FLUTTER) test test/flutter_wk_test.dart || (echo "Error while running Dart package tests"; exit 1)

.PHONY: test-swift
test-swift: ## Runs native Swift package tests
				@cd ios/flutter_wk && swift test || (echo "Error while running native Swift tests"; exit 1)

.PHONY: test-example
test-example: ## Runs example widget tests
				@cd example && $(FLUTTER) test test/widget_test.dart || (echo "Error while running example widget tests"; exit 1)

.PHONY: test-ios-build
test-ios-build: ## Builds the example app for the iOS simulator
				@cd example/ios && pod install
				@cd example && $(FLUTTER) build ios --simulator --debug || (echo "Error while building iOS simulator app"; exit 1)

.PHONY: test-native
test-native: ## Runs native Swift tests and iOS simulator build
				@$(MAKE) test-swift
				@$(MAKE) test-ios-build

.PHONY: test-all
test-all: ## Runs Dart, Swift, example, and iOS simulator checks
				@$(MAKE) test-dart
				@$(MAKE) test-swift
				@$(MAKE) test-example
				@$(MAKE) test-ios-build

.PHONY: tag
tag: ## Add a tag to the current commit
				@$(DART) run tool/tag.dart

.PHONY: tag-add
tag-add: ## Make command to add TAG. E.g: make tag-add TAG=v1.0.0
				@if [ -z "$(TAG)" ]; then echo "TAG is not set"; exit 1; fi
				@git tag $(TAG)
				@git push origin $(TAG)

.PHONY: tag-remove
tag-remove: ## Make command to delete TAG. E.g: make tag-delete TAG=v1.0.0
				@if [ -z "$(TAG)" ]; then echo "TAG is not set"; exit 1; fi
				@git tag -d $(TAG)
				@git push origin --delete $(TAG)

.PHONY: build
build:  ## Build test apk for android on example apps
				@cd example && @$(FLUTTER) clean && @$(FLUTTER) pub get && @$(FLUTTER) build apk --release && @$(FLUTTER) build ios --release --no-codesign
