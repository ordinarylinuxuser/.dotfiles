# FZF settings
export FZF_BASE="$HOME/.fzf"

export FZF_DEFAULT_COMMAND="fd --hidden --exclude='.git' --exclude='node_modules' --exclude='.gradle' --exclude='.settings' --color=always"

export FZF_DEFAULT_OPTS="
--tmux 60%
--ansi
--style full
--layout default
--border --padding 1,2
--input-label ' Input ' --header-label ' File Type '
--bind 'result:transform-list-label:
	if [[ -z \$FZF_QUERY ]]; then
		echo \" \$FZF_MATCH_COUNT items \"
	else
		echo \" \$FZF_MATCH_COUNT matches for [\$FZF_QUERY] \"
	fi
	'
--bind 'focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}'
--bind 'ctrl-r:change-list-label( Reloading the list )+reload(sleep 2; git ls-files)'
--color 'border:#aaaaaa,label:#cccccc'
--color 'preview-border:#9999cc,preview-label:#ccccff'
--color 'list-border:#669966,list-label:#99cc99'
--color 'input-border:#996666,input-label:#ffcccc'
--color 'header-border:#6699cc,header-label:#99ccff'"

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# CTRL-Y to copy the command into clipboard using pbcopy``
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --bind 'focus:+transform-header:'
  --color header:italic
  --border-label ' History '
  --header 'Press CTRL-Y to copy command into clipboard'"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="--border-label ' Search ' --preview 'bat -n {}'"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--border-label ' Go To Directory ' --preview 'tree -C {}'"

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
	cd) fzf --tmux --preview 'tree -C {} | head -200' "$@" ;;
	export | unset) fzf --tmux --preview "eval 'echo \$'{}" "$@" ;;
	ssh) fzf --tmux --preview 'dig {}' "$@" ;;
	*) fzf --tmux --preview 'bat -n --color=always {}' "$@" ;;
	esac
}

# Setup fzf
# ---------
export PATH=$FZF_BASE/bin:$PATH

source <(fzf --zsh)

# CTRL - R is not working with oh my zsh rebind to ctrl H
bindkey -M emacs '^H' fzf-history-widget
bindkey -M vicmd '^H' fzf-history-widget
bindkey -M viins '^H' fzf-history-widget
