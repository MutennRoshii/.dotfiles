# ~/.profile: executed by the command interpreter for login shells.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	source "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set ENV variables 
if [ -f "$HOME/.config/bash/env" ]; then
    source "$HOME/.config/bash/env"
fi

if [ -d "$HOME/.local/opt/flutter" ]; then
    export PATH="$HOME/.local/opt/flutter/bin:$PATH"
fi

source "$HOME/.local/share/cargo/env"
