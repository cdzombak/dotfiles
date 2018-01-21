SHELL:=/usr/bin/env bash

default: help

.PHONY: homebrew
homebrew: ## Install Homebrew
	if [ "$(uname)" != "Darwin" ]; then echo "Skipping Homebrew install because not on macOS" && exit 0; fi
	@command -v brew >/dev/null 2>&1 && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

.PHONY: dependencies
dependencies: homebrew
	@command -v stow >/dev/null 2>&1 || brew install stow 2>/dev/null || sudo apt-get install -y stow 2>/dev/null || sudo yum install -y stow 2>/dev/null || { echo >&2 "Please install GNU stow"; exit 1; }

# TODO: As noted in Aspirations, add osx-automation as a submodule
.PHONY: submodules
submodules:
	git submodule update --init

.PHONY: stow-mac
stow-mac: dependencies submodules
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

.PHONY: configure-mac
configure-mac: ## Run macOS defaults configuration script
	sh macos-configure.sh

# TODO: As noted in Aspirations, install osx-automation's scripts
# .PHONY: link-mac
# link-mac:
# 	@ln -s `pwd`/bin ~/bin

.PHONY: mac
mac: configure-mac stow-mac ## Configure a macOS system (configure-mac stow-mac)

.PHONY: stow-server
stow-server: dependencies submodules
	stow git-server
	stow screen
	stow nano
	stow tig

.PHONY: server
server: stow-server ## Configure a *nix server (stow-server)

# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
