# dotfiles

[@cdzombak](https://github.com/cdzombak/)'s dotfiles.

## Repo Contents

This repository contains configuration files that help implement my preferred ~~OS X~~ (fine, macOS) setup. It includes my current [Hammerspoon](http://www.hammerspoon.org) configuration.

There is also a `server` build target, which will install a minimal configuration on *nix servers, principally containing a stripped-down bash configuration, essential Git configuration, and a `.screenrc`.

## Dependencies

* [GNU `make`](https://www.gnu.org/software/make/)
* [GNU `stow`](https://www.gnu.org/software/stow/)

## Other macOS System Configuration

When setting up a new macOS system, in addition to dotfiles, the following are required:

* Listings of `/Applications` and `~/Applications` ([#2](https://github.com/cdzombak/dotfiles/issues/2), [#3](https://github.com/cdzombak/dotfiles/issues/3))
* `brew list` ([#4](https://github.com/cdzombak/dotfiles/issues/4))
* `npm list -g`
* Listings of Safari and Chrome extensions _(nb. [Migration Assistant](https://support.apple.com/en-us/HT204350) seems to miss Safari extensions)_
* The scripts, services, etc. in [my `osx-automation` repository](https://github.com/cdzombak/osx-automation) ([#5](https://github.com/cdzombak/dotfiles/issues/5))
* Dropbox symlinks to/from various areas in my home directory ([documented in Bear](bear://x-callback-url/open-note?id=F5E2A79A-79DD-4E05-8255-38C0D13E88AD-37872-00001D6F2B11BD01); private)
* My [IntelliJ settings repository](https://github.com/cdzombak/intellij-settings) (private)
* My [SSH configuration repository](https://github.com/cdzombak/sshconfig) (private)
* The miscellaneous configuration files in `~/Dropbox/Configs`
* Custom launch agents from `~/Library/LaunchAgents`
* Lock down `/etc/ssh/sshd_config`
* Etc. settings in System Preferences (would be nice to migrate to the configuration script)

My zsh theming is intended to work well with a dark color scheme (I use [Solarized Dark](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized)).

## Inspiration & Acknowledgements

This setup — and my further aspirations for it — are inspired by [@andrewsardone's dotfiles](https://github.com/andrewsardone/dotfiles) and [this article on managing dotfiles with GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html). My Hammerspoon configuration is heavily based on [jasonrudolph/keyboard](https://github.com/jasonrudolph/keyboard).

### Aspirations

Following Andrew's example, I'd like to move the bulk of my Mac configuration and application setup to this repo.

* Some applications can be installed [via CLI from the Mac App Store](https://github.com/mas-cli/mas) ([#2](https://github.com/cdzombak/dotfiles/issues/2)), and many others are available via [`brew cask`](https://caskroom.github.io) ([#3](https://github.com/cdzombak/dotfiles/issues/3)).
* Keeping a list of installed [Homebrew](https://brew.sh) packages here would be simple. ([#4](https://github.com/cdzombak/dotfiles/issues/4))
* It would be nice to add [`osx-automation`](https://github.com/cdzombak/osx-automation) as a submodule and symlink its contents to the correct places via `stow`. ([#5](https://github.com/cdzombak/dotfiles/issues/5))
