# dotfiles

[@cdzombak](https://github.com/cdzombak/)'s dotfiles.

## Repo Contents

**TODO:** This repository contains configuration files targeted at setting up my preferred OS X (er, macOS) setup. It includes my current [Hammerspoon](http://www.hammerspoon.org) configuration.

**TODO:** I plan to add a `server` build target, which will install a minimal configuration on *nix servers, principally containing a stripped-down bash configuration and a `.screenrc`.

## Dependencies

* [GNU `make`](https://www.gnu.org/software/make/)
* [GNU `stow`](https://www.gnu.org/software/stow/)

## Other OS X System Configuration

When setting up a new OS X system, in addition to dotfiles, the following are required:

* Listings of `/Applications` and `~/Applications`
* `brew list`
* Listings of Safari and Chrome extensions _(nb. [Migration Assistant](https://support.apple.com/en-us/HT204350) seems to miss Safari extensions)_
* The scripts, services, etc. in [my `osx-automation` repository](https://github.com/cdzombak/osx-automation)
* My IntelliJ settings repository (private)

## Inspiration & Acknowledgements

This setup — and my further aspirations for it — are inspired by [@andrewsardone's dotfiles](https://github.com/andrewsardone/dotfiles) and [this article on managing dotfiles with GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html). My Hammerspoon configuration is heavily based on [jasonrudolph/keyboard](https://github.com/jasonrudolph/keyboard).

### Aspirations

Following Andrew's example, I'd like to move the bulk of my Mac configuration and application setup to this repo.

* Some applications can be installed via CLI from the Mac App Store, and many others are available via `brew cask`.
* Keeping a list of installed Homebrew packages here would be simple.
* It would be nice to add [`osx-automation`](https://github.com/cdzombak/osx-automation) as a submodule and symlink its contents to the correct places via `stow`.
