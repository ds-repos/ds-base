# Removing the following line will break Ctrl-A and Ctrl-E
bindkey -e

PROMPT='%n@%m %1~ %# '
autoload -U colors
colors
PS1='%F{blue}%n%f@%F{green}%m%f %F{yellow}%1~%f %# '
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -la'
export EDITOR=nano

# Add /opt/bin to the PATH
export PATH="/opt/bin:$PATH"

# Source GNUstep.sh
source /System/Library/Makefiles/GNUstep.sh

# Wayland VARS
export XDG_RUNTIME_DIR=$HOME/.xdg_runtime
if [ ! -d "$XDG_RUNTIME_DIR" ]; then
  mkdir -p "$XDG_RUNTIME_DIR"
fi

export GDK_BACKEND="wayland,x11"
export XDG_CURRENT_DESKTOP=wayfire
export XDG_SESSION_DESKTOP=wayfire
