# vim:ft=zsh ts=2 sw=2 sts=2
#
# based on https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/agnoster.zsh-theme
# powerline fonts: https://github.com/powerline/fonts/tree/master/Meslo%20Dotted
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

setopt prompt_subst

# git theming default: Variables for theming the git info prompt
ZSH_THEME_GIT_PROMPT_DIRTY="*"              # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""               # Text to display if the branch is clean

# required to make virtualenvwrapper work nicely with prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

_ZSH_PROMPT_CURRENT_BG='NONE'

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  _ZSH_PROMPT_SEGMENT_SEPARATOR=$'\ue0b0'
  _ZSH_PROMPT_R_SEGMENT_SEPARATOR=$'\ue0b2'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
_zsh_prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $_ZSH_PROMPT_CURRENT_BG != 'NONE' && $1 != $_ZSH_PROMPT_CURRENT_BG ]]; then
    echo -n " %{$bg%F{$_ZSH_PROMPT_CURRENT_BG}%}$_ZSH_PROMPT_SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  _ZSH_PROMPT_CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
_zsh_prompt_end() {
  if [[ -n $_ZSH_PROMPT_CURRENT_BG ]]; then
    echo -n " %{%k%F{$_ZSH_PROMPT_CURRENT_BG}%}$_ZSH_PROMPT_SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  _ZSH_PROMPT_CURRENT_BG=''
}

# End the right prompt
_zsh_rprompt_end() {
  if [[ -n $_ZSH_PROMPT_CURRENT_BG && $_ZSH_PROMPT_CURRENT_BG != 'NONE' ]]; then
    echo -n "%{%k%F{$_ZSH_PROMPT_CURRENT_BG}%}$_ZSH_PROMPT_SEGMENT_SEPARATOR"
  fi
  echo -n "%{%k%f%}"
  _ZSH_PROMPT_CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
_zsh_prompt_context() {
  if [[ -n "$OSCARSIERRA_ENV" ]]; then
    _zsh_prompt_segment magenta black "$(echo ${OSCARSIERRA_ENV:0:4} | tr -d ao)"
  fi
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    _zsh_prompt_segment black default "%(!.%{%F{yellow}%}.)$USER@$SHORT_HOST"
  fi
}

# Git: branch/detached head, dirty status
_zsh_prompt_git() {
  (( $+commands[git] )) || return
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      _zsh_prompt_segment yellow black
    else
      _zsh_prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

_zsh_prompt_bzr() {
    (( $+commands[bzr] )) || return
    if (bzr status >/dev/null 2>&1); then
        status_mod=`bzr status | head -n1 | grep "modified" | wc -m`
        status_all=`bzr status | head -n1 | wc -m`
        revision=`bzr log | head -n2 | tail -n1 | sed 's/^revno: //'`
        if [[ $status_mod -gt 0 ]] ; then
            _zsh_prompt_segment yellow black
            echo -n "bzr@"$revision "✚ "
        else
            if [[ $status_all -gt 0 ]] ; then
                _zsh_prompt_segment yellow black
                echo -n "bzr@"$revision

            else
                _zsh_prompt_segment green black
                echo -n "bzr@"$revision
            fi
        fi
    fi
}

_zsh_prompt_hg() {
  (( $+commands[hg] )) || return
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        _zsh_prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        _zsh_prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        _zsh_prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if `hg st | grep -q "^\?"`; then
        _zsh_prompt_segment red black
        st='±'
      elif `hg st | grep -q "^[MA]"`; then
        _zsh_prompt_segment yellow black
        st='±'
      else
        _zsh_prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
_zsh_prompt_dir() {
  _zsh_prompt_segment blue black '%~'
}

_zsh_rprompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $1 != $_ZSH_PROMPT_CURRENT_BG ]]; then
    echo -n " %{%K{$_ZSH_PROMPT_CURRENT_BG}%F{$1}%}$_ZSH_PROMPT_R_SEGMENT_SEPARATOR"
  fi
  echo -n "%{$bg%}%{$fg%} "
  _ZSH_PROMPT_CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

_zsh_rprompt_local_env() {
  if [[ -n "$_RPROMPT_ENV" ]]; then
    _zsh_rprompt_segment green black "$_RPROMPT_ENV"
  fi
}

_zsh_rprompt_aws_region() {
  if [[ -n "$AWS_REGION" ]]; then
    _zsh_rprompt_segment yellow black "$AWS_REGION"
  fi
}

_zsh_rprompt_aws_profile() {
  if [[ -n "$AWS_PROFILE" ]]; then
    if [[ "$AWS_PROFILE" =~ "^prod" ]]; then
        _zsh_rprompt_segment red black "${AWS_PROFILE#*_}"
    # elif [[ "$AWS_PROFILE" =~ "^internal_panther-dev-" ]]; then
    #     _zsh_rprompt_segment green black "${AWS_PROFILE#*internal_panther-dev-}"
    else
        _zsh_rprompt_segment green black "${AWS_PROFILE#*_}"
    fi
  fi
}

_zsh_rprompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    _zsh_rprompt_segment cyan black "`basename $virtualenv_path`"
  fi
}

# kubectl context
source ~/.zsh/kubectl-prompt.zsh

_zsh_rprompt_kubectl() {
  if [[ $_ZSH_RPROMPT_K8S_CONTEXT = true ]]; then
    local kcprompt
    kcprompt=$(echo -n $_ZSH_KUBECTL_PROMPT | awk -F '/' '{print $1}' | awk -F '_' '{print $2 "/" $4}')
    _zsh_rprompt_segment magenta black "$kcprompt"
  fi
}

k8s-ctx-show() {
  _ZSH_RPROMPT_K8S_CONTEXT=true
}

k8s-ctx-hide() {
  _ZSH_RPROMPT_K8S_CONTEXT=false
}

kubernetes-context-show() {
  k8s-ctx-show
}

kubernetes-context-hide() {
  k8s-ctx-hide
}

# gcloud context

alias gcloud="gcloud-ctx-show; gcloud"

_zsh_rprompt_gcloud() {
  if [[ $_ZSH_RPROMPT_GCLOUD_CONTEXT = true ]]; then
    local gcprompt
    gcprompt="GCP $(echo -n $(grep --context=0 --max-count=1 'account =' "$HOME/.config/gcloud/configurations/config_default" | sed 's/account = //' | sed 's/.com$//'))"
    _zsh_rprompt_segment green black "$gcprompt"
  fi
}

gcloud-ctx-show() {
  _ZSH_RPROMPT_GCLOUD_CONTEXT=true
}

gcloud-ctx-hide() {
  _ZSH_RPROMPT_GCLOUD_CONTEXT=false
}

_zsh_rprompt_asdf() {
  local expected_python expected_node current_python current_node
  
  # Read expected versions from ~/.tool-versions
  if [[ -f "$HOME/.tool-versions" ]]; then
    expected_python=$(grep '^python ' "$HOME/.tool-versions" | awk '{print $2}')
    expected_node=$(grep '^nodejs ' "$HOME/.tool-versions" | awk '{print $2}')
  fi
  
  # Get current versions
  current_python=$(python3 -V 2>&1 | cut -f 2 -d ' ')
  current_node=$(node --version 2>&1 | sed 's/^v//')
  
  # Show Python version only if different from expected
  if [[ -n "$expected_python" && "$current_python" != "$expected_python" ]]; then
    _zsh_rprompt_segment black cyan "py $current_python"
  fi
  
  # Show Node version only if different from expected
  if [[ -n "$expected_node" && "$current_node" != "$expected_node" ]]; then
    _zsh_rprompt_segment black cyan "njs $current_node"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
_zsh_prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && _zsh_prompt_segment black default "$symbols"
}

## Main prompt
_zsh_build_prompt() {
  RETVAL=$?
  _zsh_prompt_status
  _zsh_prompt_context
  _zsh_prompt_dir
  _zsh_prompt_git
  #_zsh_prompt_bzr
  #_zsh_prompt_hg
  _zsh_prompt_end
}

## Right prompt
_zsh_build_rprompt() {
  _zsh_rprompt_local_env
  _zsh_rprompt_virtualenv
  _zsh_rprompt_asdf
  #_zsh_rprompt_kubectl
  _zsh_rprompt_aws_region
  _zsh_rprompt_aws_profile
  _zsh_rprompt_gcloud
  _zsh_rprompt_end
}

PROMPT='%{%f%b%k%}$(_zsh_build_prompt) '
RPROMPT='$(_zsh_build_rprompt)'
