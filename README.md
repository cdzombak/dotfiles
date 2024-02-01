# dotfiles

[@cdzombak](https://github.com/cdzombak/)'s dotfiles & system setup scripts.

## Repo Contents

This repository contains configuration files and scripts that help implement my preferred macOS setup. It includes, among other things, my current [Hammerspoon](http://www.hammerspoon.org) configuration.

There is also a `server` build target, which will install a minimal configuration and useful software on Linux servers (it'll work on "client" machines, too, but it's oriented for my current common Linux server usage).

## Dependencies

- [GNU `make`](https://www.gnu.org/software/make/)
- [GNU `stow`](https://www.gnu.org/software/stow/)
- _macOS only:_ [Homebrew](https://brew.sh)

On macOS, the relevant `make` targets will install these dependencies with Homebrew.

My zsh theming is intended to work well with a dark color scheme (I use [Solarized Dark](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized)).

## Installation

Begin by [installing my SSH configuration](https://github.com/cdzombak/sshconfig/blob/master/README.md#installation) (private; see [my blog post about this setup](https://www.dzombak.com/blog/2021/02/Securing-my-personal-SSH-infrastructure-with-Yubikeys.html)).

```shell
# in ~

git clone https://github.com/cdzombak/dotfiles.git .dotfiles
cd .dotfiles/
make [ mac-all | linux-all ]
```

On an extremely minimal deb-based Linux install, you will need to install `locales`. Optionally, run `apt install dialog apt-utils` for a better dpkg-reconfigure UX.

On Linux, also clone the dotfiles and run `make linux-all` from a root terminal (`sudo -i`).

Running `make` with no target prints help.

## Other macOS System Configuration

When setting up a new macOS system, in addition to dotfiles, the following are required:

- My [SSH configuration repository](https://github.com/cdzombak/sshconfig) (private; see [my blog post about this setup](https://www.dzombak.com/blog/2021/02/Securing-my-personal-SSH-infrastructure-with-Yubikeys.html))
- My [macos-automation repository](https://github.com/cdzombak/macos-automation) (installed automatically during `make mac-software`)
- My [Sublime Text settings repository](https://github.com/cdzombak/sublime-text-config) (private; installed automatically during `make mac-software`)
- Miscellaneous application configuration files & resources I store in `~/.config/macos` and sync between machines with [Syncthing](https://www.syncthing.net) (eg. Alfred, Choosy, Dash, iTerm2)
- Various settings in System Preferences (though [the configuration script](https://github.com/cdzombak/dotfiles/blob/master/mac/configure.sh) already covers many of the more important settings)

## Inspiration & Acknowledgements

This setup — and my further aspirations for it — are inspired by:

- [@andrewsardone's dotfiles](https://github.com/andrewsardone/dotfiles)
- [This article on managing dotfiles with GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
- [@mathiasbynens's macOS configuration script](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
- My Hammerspoon configuration is heavily based on [jasonrudolph/keyboard](https://github.com/jasonrudolph/keyboard)
