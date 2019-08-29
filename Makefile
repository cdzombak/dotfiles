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

# Platform Verfication

.PHONY: require-macos
require-macos:
	@if [ "$$(uname)" != "Darwin" ]; then echo "This target must be run on macOS." && exit 2; fi

.PHONY: require-non-macos
require-non-macos:
	@if [ "$$(uname)" == "Darwin" ]; then echo "This target is not intended to run on macOS." && exit 2; fi

# macOS Targets

.PHONY: mac-stow
mac-stow: dependencies submodules require-macos ## Link macOS configuration files in $HOME
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
	ln -s ~/.dotfiles/kubectl-aliases/.kubectl_aliases ~/.kubectl_aliases

.PHONY: mac-configure
mac-configure: require-macos ## Run macOS configuration script
	@bash ./macos-configure.sh

.PHONY: mac-software
mac-software: require-macos submodules ## Install macOS software suite (this can take a long time)
	@bash ./osx-automation/script/install.sh
	@bash ./macos-software-install.sh

.PHONY: mac-homedir
mac-homedir: require-macos ## Set up basic macOS home directory structure
	@bash ./macos-homedir.sh

.PHONY: mac
mac: require-macos mac-homedir mac-configure mac-stow mac-software ## Install Homebrew, configure a macOS system, and install other Mac software. *Recommended entry point.*

# Server (*nix) Targets

.PHONY: server-stow
server-stow: dependencies submodules require-non-macos
	stow git-server
	stow screen
	stow nano
	stow tig

.PHONY: server-bash-cfg
server-bash-cfg: require-non-macos ## Integrate Bash configuration files in $HOME
	@bash ./bash-server/integrate.sh

.PHONY: server-homedir
server-homedir: require-non-macos ## Set up basic Linux home directory structure
	@bash ./server-homedir.sh

.PHONY: server-software
server-software: server-homedir
	@bash ./server-software-install.sh ## Install some extra software on Linux

.PHONY: server
server: require-non-macos server-homedir server-stow server-bash-cfg server-software ## Configure a Linux server (assumes Ubuntu or Debian). *Recommended entry point.*
