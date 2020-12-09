# dotfiles

[@cdzombak](https://github.com/cdzombak/)'s dotfiles & system setup scripts.

## Repo Contents

This repository contains configuration files and scripts that help implement my preferred macOS setup. It includes, among other things, my current [Hammerspoon](http://www.hammerspoon.org) configuration.

There is also a `server` build target, which will install a minimal configuration and useful software on Linux servers (it'll work on "client" machines, too, but it's oriented for my current common Linux server usage).

## Dependencies

* [GNU `make`](https://www.gnu.org/software/make/)
* [GNU `stow`](https://www.gnu.org/software/stow/)
* *macOS only:* [Homebrew](https://brew.sh)

On macOS, the relevant `make` targets will install these dependencies with Homebrew.

My zsh theming is intended to work well with a dark color scheme (I use [Solarized Dark](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized)).

## Installation

Begin by [installing my SSH configuration](https://github.com/cdzombak/sshconfig/blob/master/README.md#installation) (private).

```bash
# in ~

git clone git@github.com:cdzombak/dotfiles.git .dotfiles
cd .dotfiles/
make [ mac | server ]
```

Running `make` with no target prints help.

## Other macOS System Configuration

When setting up a new macOS system, in addition to dotfiles, the following are required:

* My [SSH configuration repository](https://github.com/cdzombak/sshconfig) (private)
* My [osx-automation repository](https://github.com/cdzombak/osx-automation/tree/edbc14b506e1b31b9a86e7298fb7c343d81fc289) (installed automatically during `make mac-software`)
* My [Sublime Text settings repository](https://github.com/cdzombak/sublime-text-config) (private; installed automatically during `make mac-software`)
* My [JetBrains settings repository](https://github.com/cdzombak/intellij-settings) (private; install manually when first opening these IDEs)
* Miscellaneous tools' configuration files & resources I store in `~/Sync/Configs` (eg. Alfred, Choosy, Dash, iTerm2, SuperDuper, & VPN configs)
* Various settings in System Preferences (though [the configuration script](https://github.com/cdzombak/dotfiles/blob/master/macos-configure.sh), which already covers many of the more important settings)

## Inspiration & Acknowledgements

This setup — and my further aspirations for it — are inspired by [@andrewsardone's dotfiles](https://github.com/andrewsardone/dotfiles) and [this article on managing dotfiles with GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html). My Hammerspoon configuration is heavily based on [jasonrudolph/keyboard](https://github.com/jasonrudolph/keyboard).
