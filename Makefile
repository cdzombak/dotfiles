SHELL:=/usr/bin/env bash

default: help

# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Cross-Platform Targets

.PHONY: homebrew
homebrew: ## Install Homebrew (no-op on other than macOS)
	@bash install-homebrew.sh

.PHONY: dependencies
dependencies: homebrew
	@command -v stow >/dev/null 2>&1 || brew install stow 2>/dev/null || sudo apt-get install -y stow 2>/dev/null || sudo yum install -y stow 2>/dev/null || { echo >&2 "Please install GNU stow"; exit 1; }

# TODO: As noted in Aspirations, add osx-automation as a submodule
.PHONY: submodules
submodules:
	git submodule update --init

# Platform Verfication

.PHONY: require-macos
require-macos:
	@if [ "$$(uname)" != "Darwin" ]; then echo "This target must be run on macOS." && exit 2; fi

.PHONY: require-non-macos
require-non-macos:
	@if [ "$$(uname)" == "Darwin" ]; then echo "This target is not intended to run on macOS." && exit 2; fi

# macOS Targets

.PHONY: stow-mac
stow-mac: dependencies submodules require-macos
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
configure-mac: require-macos
	@bash macos-configure.sh

.PHONY: software-mac
software-mac: require-macos ## Install macOS software suite. This can take a long time.
	@bash macos-software-install.sh

# TODO: As noted in Aspirations, install osx-automation's scripts
# .PHONY: link-mac
# link-mac:
#   @ln -s `pwd`/bin ~/bin

.PHONY: mac
mac: require-macos configure-mac stow-mac software-mac ## Install Homebrew & configure a macOS system

# Server (*nix) Targets

.PHONY: stow-server
stow-server: dependencies submodules require-non-macos
	stow git-server
	stow screen
	stow nano
	stow tig

.PHONY: integrate-bash-server
integrate-bash-server: require-non-macos
	@bash bash-server/integrate.sh

.PHONY: server-homedir
server-homedir: require-non-macos
	@bash server-homedir.sh

.PHONY: software-server
software-server: server-homedir
	@bash server-software-install.sh

.PHONY: server
server: require-non-macos server-homedir stow-server integrate-bash-server software-server ## Configure a *nix server (currently likely assumes Ubuntu or Debian)

