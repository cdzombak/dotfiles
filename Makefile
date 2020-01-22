SHELL:=/usr/bin/env bash

default: help

# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Cross-Platform Targets

.PHONY: homebrew
homebrew: ## Install Homebrew (no-op on other than macOS)
	@bash ./install-homebrew.sh

.PHONY: dependencies
dependencies: homebrew ## Install dependencies
	@command -v stow >/dev/null 2>&1 || brew install stow 2>/dev/null || sudo apt-get install -y stow 2>/dev/null || sudo yum install -y stow 2>/dev/null || { echo >&2 "Please install GNU stow"; exit 1; }
	@command -v curl >/dev/null 2>&1 || brew install curl 2>/dev/null || sudo apt-get install -y curl 2>/dev/null || sudo yum install -y curl 2>/dev/null || { echo >&2 "Please install curl"; exit 1; }
	@command -v wget >/dev/null 2>&1 || brew install wget 2>/dev/null || sudo apt-get install -y wget 2>/dev/null || sudo yum install -y wget 2>/dev/null || { echo >&2 "Please install wget"; exit 1; }
	@command -v jq >/dev/null 2>&1 || brew install jq 2>/dev/null || sudo apt-get install -y jq 2>/dev/null || sudo yum install -y jq 2>/dev/null || { echo >&2 "Please install jq"; exit 1; }

.PHONY: submodules
submodules:
	@bash ./init-submodules.sh

.PHONY: setupnote
setupnote:
	@bash ./touch-systemsetup-note.sh
	@echo ""

.PHONY: reset-choices
reset-choices: ## Reset any choices persisted in ~/.local/dotfiles
	rm -rf ~/.local/dotfiles
	mkdir -p ~/.local/dotfiles

# Platform Verfication

.PHONY: require-macos
require-macos:
	@if [ "$$(uname)" != "Darwin" ]; then echo "This target must be run on macOS." && exit 2; fi

.PHONY: require-linux
require-linux:
	@if [ "$$(uname)" != "Linux" ]; then echo "This target must be run on Linux." && exit 2; fi

# macOS Targets

.PHONY: mac-stow
mac-stow: dependencies submodules require-macos ## Link macOS configuration files in $HOME
	@echo -ne "\033[0;37m"
	@echo -n "Link macOS configuration files in $$HOME..."
	@echo -e "`tput sgr0`"
	@echo ""
	stow git
	stow ruby
	stow hammerspoon
	stow login
	stow lldb
	stow tig
	stow screen
	stow profile
	stow zsh
	stow nano
	[ -L ~/.kubectl_aliases ] || ln -s ~/.dotfiles/kubectl-aliases/.kubectl_aliases ~/.kubectl_aliases
	@echo ""

.PHONY: mac-configure
mac-configure: require-macos setupnote ## Run macOS configuration script
	@bash ./macos-configure.sh
	@echo ""

.PHONY: mac-configure-post-software-install
mac-configure-post-software-install: require-macos mac-software ## Run final macOS configuration script, for software installed by the mac-software target
	@bash ./macos-configure-post-software-install.sh
	@echo ""

.PHONY: mac-software
mac-software: require-macos submodules setupnote ## Install macOS software suite (this can take a long time)
	@bash ./osx-automation/script/install.sh
	@echo ""
	@bash ./macos-software-install.sh
	@echo ""

.PHONY: mac-homedir
mac-homedir: require-macos ## Set up basic macOS home directory structure
	@bash ./macos-homedir.sh
	@echo ""

.PHONY: mac-safari-extensions
mac-safari-extensions: require-macos
	@bash ./macos-safari-extensions.sh
	@echo ""

.PHONY: mac-open-setupnote
mac-open-setupnote: require-macos setupnote ## Open the system setup note
	open -a Typora ~/SystemSetup.md

.PHONY: mac
mac: require-macos mac-configure mac-homedir mac-stow mac-software mac-safari-extensions mac-configure-post-software-install mac-open-setupnote ## Install Homebrew, configure a macOS system, and install other Mac software. *Recommended entry point.*

# Server (Linux) Targets

.PHONY: server-stow
server-stow: dependencies submodules require-linux
	stow git-server
	stow screen
	stow nano
	stow tig

.PHONY: server-bash-cfg
server-bash-cfg: require-linux ## Integrate Bash configuration files in $HOME
	@bash ./bash-server/integrate.sh

.PHONY: server-homedir
server-homedir: require-linux ## Set up basic Linux home directory structure
	@bash ./server-homedir.sh

.PHONY: server-software
server-software: server-homedir ## Install some extra software on Linux (requires sudo)
	@bash ./server-software-install.sh

.PHONY: server
server: require-linux server-homedir server-stow server-bash-cfg server-software ## Configure a Linux server. *Recommended entry point.*
