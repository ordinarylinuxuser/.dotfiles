#dotnet
export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_INSTALL_DIR=$HOME/.dotnet
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

export HISTCONTROL=ignoreboth

#
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git nvm colored-man-pages command-not-found pip themes zsh-interactive-cd zsh-syntax-highlighting zsh-autosuggestions)

# source completion and config external files
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh
[ -f ~/.azcompletion.zsh ] && source ~/.az.completion.zsh
[ -f ~/.fzf.conf.zsh ] && source ~/.fzf.conf.zsh
[ -f ~/.dotnet.completion.zsh ] && source ~/.dotnet.completion.zsh
[ -f ~/.helm.completion.zsh ] && source ~/.helm.completion.zsh
[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.aliases.zsh ] && source ~/.aliases.zsh

if command -v zoxide &> /dev/null; then
  # start zoxide
  eval "$(zoxide init --cmd cd zsh)"
fi

# start tmux , here i am only starting tmux if i am using alacritty
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -n "$KONSOLE_VERSION" ]; then
  exec tmux
fi
