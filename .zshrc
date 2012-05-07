#
# Sets Oh My Zsh options.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Set the path to Oh My Zsh.
export OMZ="$HOME/.oh-my-zsh"

# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':omz:module:editor' keymap 'vi'

# Auto convert .... to ../..
zstyle ':omz:module:editor' dot-expansion 'no'

# Set case-sensitivity for completion, history lookup, etc.
zstyle ':omz:*:*' case-sensitive 'yes'

# Color output (auto set to 'no' on dumb terminals).
zstyle ':omz:*:*' color 'yes'

# Auto set the tab and window titles.
zstyle ':omz:module:terminal' auto-title 'no'

# Set the Zsh modules to load (man zshmodules).
# zstyle ':omz:load' zmodule 'attr' 'stat'

# Set the Zsh functions to load (man zshcontrib).
# zstyle ':omz:load' zfunction 'zargs' 'zmv'

# Set the Oh My Zsh modules to load (browse modules).
zstyle ':omz:load' omodule 'environment' 'terminal' 'editor' 'completion' \
  'history' 'directory' 'spectrum' 'alias' 'utility' 'prompt' 'archive' \
  'git' 'osx' 'node' 'python' 

# Set the prompt theme to load.
# Setting it to 'random' loads a random theme.
# Auto set to 'off' on dumb terminals.
# Others: sorin steeef
zstyle ':omz:module:prompt' theme 'minimal'

# This will make you shout: OH MY ZSHELL!
source "$HOME/.oh-my-zsh/init.zsh"

# Customize to your needs...
FILES=(~/.alias ~/share/sh/python ~/share/sh/vim ~/share/sh/vimpager /usr/local/etc/bash_completion.d/git-completion.bash)
for FILE in ${FILES} ; do
    if [[ -f ${FILE} ]] ; then
        source ${FILE}
    fi
done

if [[ "$OSTYPE" == darwin* ]] ; then
    export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"
else
    export PATH="$HOME/bin:$PATH"
fi
export NODE_PATH="/usr/local/lib/node_modules"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
