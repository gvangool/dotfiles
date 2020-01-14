# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [[ "${COLORTERM}" == "gnome-terminal" && "${TERM}" == "xterm"  ]]; then
    export TERM="gnome-256color"
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    gnome-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# colors
BRIGHT="\[`tput bold`\]"
DIM="\[`tput dim`\]"
GREEN="\[`tput setaf 2 sgr0`\]"
BGREEN="${BRIGHT}${GREEN}"
RED="\[`tput setaf 1 sgr0`\]"
BRED="${BRIGHT}${RED}"
BLUE="\[`tput setaf 4 sgr0`\]"
BBLUE="${BRIGHT}${BLUE}"
CYAN="\[`tput setaf 6 sgr0`\]"
DEFAULT="\[`tput sgr0`\]"
NORMAL="${DIM}${DEFAULT}"

if [ "$color_prompt" = yes ]; then
    PS1_="${debian_chroot:+($debian_chroot)}${BGREEN}\u${NORMAL}@${BRED}\h${NORMAL}:${BBLUE}\w${NORMAL}\$ "
    PS1=$PS1_
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
if [ -d /usr/local/etc/bash_completion.d ] && ! shopt -oq posix; then
    source /usr/local/etc/bash_completion.d/*
fi

for FILE in ~/share/sh/python ~/share/sh/vim ~/.alias ~/share/sh/vimpager ~/share/sh/rvm ~/share/sh/go ~/share/sh/postgres ~/.dockerfunc ~/share/sh/secrets ~/share/sh/node ~/.cargo/env ; do
    if [ -f ${FILE} ]; then
        source ${FILE}
    fi
done

if [[ "$OSTYPE" == darwin* ]] ; then
    export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"
else
    export PATH="$HOME/bin:$PATH"
fi

# git stuff
__git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /';
}

__git_repo(){
    echo "$(basename $(git rev-parse --show-toplevel)) ";
}

export MTR_OPTIONS="--show-ips --aslookup"
