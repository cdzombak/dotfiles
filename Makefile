default: help

.PHONY: dependencies
dependencies: ## Install dependencies
	@command -v stow >/dev/null 2>&1 || brew install stow 2>/dev/null || sudo apt-get install -y stow 2>/dev/null || sudo yum install -y stow 2>/dev/null || { echo >&2 "Please install GNU stow"; exit 1; }

# TODO: As noted in Aspirations, include osx-automation as a submodule
# submodules:
# 	git submodule update --init

.PHONY: stow-mac
stow-mac: ## Link dotfiles for setup on macOS
	stow git
	stow ruby
	stow hammerspoon
	stow login

# TODO: OS X config script
# mac:
# 	sh osx/index.sh

# TODO: As noted in Aspirations, install osx-automation's scripts
# link-bin:
# 	@ln -s `pwd`/bin ~/bin

.PHONY: mac
mac: dependencies stow-mac ## Configure a macOS system (dependencies, stow-mac)

# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
