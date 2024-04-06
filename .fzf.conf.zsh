# FZF settings
export FZF_BASE="$HOME/.fzf"
export FZF_DEFAULT_COMMAND="fd --hidden --exclude='.git' --exclude='node_modules' --exclude='.gradle' --exclude='.settings' --color=always"
export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border --ansi'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
	fd --hidden --follow --exclude=".git" --exclude="node_modules" --exclude=".gradle" --exclude=".settings" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
	fd --type d --hidden --follow --exclude=".git" --exclude="node_modules" --exclude=".gradle" --exclude=".settings" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
	local command=$1
	shift

	case "$command" in
	cd) fzf --preview 'tree -C {} | head -200' "$@" ;;
	export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
	ssh) fzf --preview 'dig {}' "$@" ;;
	*) fzf --preview 'bat -n --color=always {}' "$@" ;;
	esac
}
