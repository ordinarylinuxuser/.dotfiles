# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
# map exa commands to normal ls commands
alias ll="eza -a -l -g --icons -s=type"
alias ls="eza -a --icons -s=type"
alias lt="eza --tree --icons -a -I '.git|__pycache__|.mypy_cache|.ipynb_checkpoints'"
alias vm="~/scripts/connect_vm.sh"
alias lg="lazygit"
