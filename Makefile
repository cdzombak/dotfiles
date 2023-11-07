export PATH := /usr/local/bin:/opt/homebrew/bin:$(PATH)
SHELL:=/usr/bin/env bash

default: help

.PHONY: help
help: # via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Cross-Platform Targets

.PHONY: homebrew
homebrew:
	@if [ "$$(uname)" == "Darwin" ]; then ./mac/install-homebrew.sh; fi

.PHONY: rosetta
rosetta:
	@if [ "$$(uname)" == "Darwin" ]; then ./mac/rosetta.sh; fi

.PHONY: dependencies
dependencies: rosetta homebrew ## Install key dependencies
	@command -v stow >/dev/null 2>&1 || brew install stow 2>/dev/null || sudo apt-get install -y stow 2>/dev/null || sudo yum install -y stow 2>/dev/null || { echo >&2 "Please install GNU stow"; exit 1; }
	@command -v curl >/dev/null 2>&1 || brew install curl 2>/dev/null || sudo apt-get install -y curl 2>/dev/null || sudo yum install -y curl 2>/dev/null || { echo >&2 "Please install curl"; exit 1; }
	@command -v wget >/dev/null 2>&1 || brew install wget 2>/dev/null || sudo apt-get install -y wget 2>/dev/null || sudo yum install -y wget 2>/dev/null || { echo >&2 "Please install wget"; exit 1; }
	@command -v jq >/dev/null 2>&1 || brew install jq 2>/dev/null || sudo apt-get install -y jq 2>/dev/null || sudo yum install -y jq 2>/dev/null || { echo >&2 "Please install jq"; exit 1; }

.PHONY: submodules
submodules:
	@git submodule update --init

.PHONY: setupnote
setupnote:
	@bash ./touch-systemsetup-note.sh
	@echo ""

.PHONY: reset-choices
reset-choices: ## Reset any choices persisted in ~/.config/dotfiles
	rm -rf ~/.config/dotfiles
	mkdir -p ~/.config/dotfiles

# Platform Verfication

.PHONY: require-macos
require-macos:
	@if [ "$$(uname)" != "Darwin" ]; then echo "This target must be run on macOS." && exit 2; fi

.PHONY: require-linux
require-linux:
	@if [ "$$(uname)" != "Linux" ]; then echo "This target must be run on Linux." && exit 2; fi

# macOS Targets

.PHONY: mac-homedir
mac-homedir: require-macos ## Set up basic macOS home directory structure
	@bash ./mac/homedir.sh
	@echo ""

.PHONY: mac-configure
mac-configure: require-macos setupnote submodules ## Run macOS configuration script
	@bash ./mac/configure.sh
	@echo ""

.PHONY: mac-stow
mac-stow: require-macos dependencies submodules ## Link macOS configuration files in $HOME
	@bash ./mac/stow.sh
	@echo ""

.PHONY: mac-software
mac-software: require-macos dependencies submodules setupnote rosetta ## Install and configure macOS software suite (this can take a long time)
	@echo -ne "\033[0;37m"
	@echo "WARNING: the configuration part of this setup will quit & open some apps automatically."
	@echo "         Use Ctrl-C to exit if you have work open right now."
	@echo -e "`tput sgr0`"
	@echo ""
	@bash ./mac/software-install.sh
	@echo ""
	@bash ./mac/configure-post-software-install.sh
	@echo ""

.PHONY: mac-automation-repo
mac-automation-repo: ## Update and install the macos-automation repo
	@bash ./mac/update-macos-automation.sh
	@echo ""
	@bash ./macos-automation/script/restore-resources.sh
	@echo ""
	@bash ./macos-automation/script/install.sh
	@echo ""

.PHONY: mac-open-setupnote
mac-open-setupnote: require-macos setupnote ## Open the SystemSetup note
	open -a Typora ~/SystemSetup.md

.PHONY: mac-all
mac-all: dependencies require-macos mac-homedir mac-configure mac-stow mac-software mac-automation-repo mac-open-setupnote ## Install Homebrew, configure a macOS system, and install other Mac software. *Recommended entry point.*

# Linux Targets

.PHONY: linux-stow
linux-stow: dependencies submodules require-linux ## Link Linux configuration files in $HOME
	@bash ./linux/stow.sh

.PHONY: linux-homedir
linux-homedir: require-linux ## Set up basic Linux home directory structure
	@bash ./linux/homedir.sh

.PHONY: linux-user
linux-user: setupnote linux-stow linux-homedir ## User-level (ie. nothing systemwide) setup on Linux

.PHONY: linux-configure
linux-configure: setupnote require-linux ## Core Linux configuration (requires sudo)
	@bash ./linux/configure.sh

.PHONY: linux-software
linux-software: setupnote require-linux linux-homedir ## Set up core software on Linux (requires sudo)
	@bash ./linux/software-install.sh

.PHONY: linux-all
linux-all: require-linux linux-user linux-configure linux-software ## Configure and install core software on a Linux machine. *Recommended entry point.*
