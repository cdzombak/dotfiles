# dotfiles

[@cdzombak](https://github.com/cdzombak/)'s dotfiles.

## Repo Contents

This repository contains configuration files that help implement my preferred macOS setup. It includes my current [Hammerspoon](http://www.hammerspoon.org) configuration.

There is also a `server` build target, which will install a minimal configuration on *nix servers, principally containing a stripped-down bash configuration, essential Git configuration, and a `.screenrc`.

## Dependencies

* [GNU `make`](https://www.gnu.org/software/make/)
* [GNU `stow`](https://www.gnu.org/software/stow/)

My zsh theming is intended to work well with a dark color scheme (I use [Solarized Dark](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized)).

## TODO

* complete Dropbox integration/linking for personal computers ([documented in Bear](bear://x-callback-url/open-note?id=F5E2A79A-79DD-4E05-8255-38C0D13E88AD-37872-00001D6F2B11BD01)
* checkin custom launch agents (maybe into osx-autmoation)
* move system prefs & keyboard shortcuts into configure script as possible
* note & try to automate followup steps (apps configuration, menubar, etc. esp. Choosy)

## Other macOS System Configuration

When setting up a new macOS system, in addition to dotfiles, the following are required:

* Listings of Safari extensions _(nb. [Migration Assistant](https://support.apple.com/en-us/HT204350) seems to miss these)_
* My [SSH configuration repository](https://github.com/cdzombak/sshconfig) (private)
* My [IntelliJ settings repository](https://github.com/cdzombak/intellij-settings) (private)
* Miscellaneous tools' configuration files & resources I store in `~/Dropbox/Configs`
* Custom launch agents from `~/Library/LaunchAgents`
* Etc. settings in System Preferences (would be nice to migrate to [the configuration script](https://github.com/cdzombak/dotfiles/blob/master/macos-configure.sh), which already covers many of the more important settings)

## Inspiration & Acknowledgements

This setup — and my further aspirations for it — are inspired by [@andrewsardone's dotfiles](https://github.com/andrewsardone/dotfiles) and [this article on managing dotfiles with GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html). My Hammerspoon configuration is heavily based on [jasonrudolph/keyboard](https://github.com/jasonrudolph/keyboard).
