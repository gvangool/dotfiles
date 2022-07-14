#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Gert Van Gool <gertvangool@gmail.com>
#

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

fpath=(${HOME}/.zprompts $fpath)

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
FILES=(~/.alias ~/share/sh/python ~/share/sh/vim ~/share/sh/vimpager ~/share/sh/rvm ~/share/sh/postgres ~/share/sh/go ~/.dockerfunc ~/share/sh/secrets ~/share/sh/node ~/.ssh-agent ~/.cargo/env)
for FILE in ${FILES} ; do
    if [[ -f ${FILE} ]] ; then
        source ${FILE}
    fi
done

export PATH="$HOME/bin:$PATH"
if [[ "$OSTYPE" == darwin* ]] ; then
    # Fix tmux support :)
    if [[ "x$TMUX" != "x" ]] ; then
        # Only if it's installed
        if (( $+commands[reattach-to-user-namespace] )) ; then
            tmux set-option -g default-command "reattach-to-user-namespace -l zsh"
        fi
    fi
    if [[ -d "/usr/local/texlive/2013/bin" ]] ; then
        export PATH="/usr/local/texlive/2013/bin/x86_64-darwin:$PATH"
    fi
fi

if (( $+commands[direnv] )) ; then
    eval "$(direnv hook $0)"
fi

export MTR_OPTIONS="--show-ips --aslookup"

if [ -d "/Applications/YubiKey Manager.app/Contents/MacOS/" ] ; then
    export PATH="/Applications/YubiKey Manager.app/Contents/MacOS/:$PATH"
fi

if [ -d /home/linuxbrew/.linuxbrew ] ; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
