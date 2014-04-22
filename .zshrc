#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

fpath=(${HOME}/.zprompts $fpath)

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
FILES=(~/.alias ~/share/sh/python ~/share/sh/vim ~/share/sh/vimpager ~/share/sh/rvm ~/share/sh/postgres) # /usr/local/etc/bash_completion.d/git-completion.bash)
for FILE in ${FILES} ; do
    if [[ -f ${FILE} ]] ; then
        source ${FILE}
    fi
done

if [[ "$OSTYPE" == darwin* ]] ; then
    export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"
    # Fix tmux support :)
    if [[ "x$TMUX" != "x" ]] ; then
        # Only if it's installed
        if (( $+commands[reattach-to-user-namespace] )) ; then
            tmux set-option -g default-command "reattach-to-user-namespace -l zsh"
        fi
    fi
    if (( $+commands[node] )) ; then
        export NODE_PATH="/usr/local/lib/node_modules"
        export PATH="/usr/local/share/npm/bin:${PATH}"
    fi
    if [[ -d "/usr/local/texlive/2013/bin" ]] ; then
        export PATH="/usr/local/texlive/2013/bin/x86_64-darwin:$PATH"
    fi
else
    export PATH="$HOME/bin:$PATH"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if (( $+commands[direnv] )) ; then
    eval "$(direnv hook $0)"
fi
