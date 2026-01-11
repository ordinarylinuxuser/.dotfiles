# Define the history file path
HISTFILE=~/.zsh_history

# Set the maximum number of history lines in memory
HISTSIZE=1000000

# Set the maximum number of history lines saved to the file
SAVEHIST=1000000

# Share history across all sessions (recommended for multiple terminal windows)
setopt SHARE_HISTORY

# Append new commands to the history file immediately
setopt INC_APPEND_HISTORY

# Record the time when each command was executed
setopt EXTENDED_HISTORY

# Don't record an entry that was just recorded again
setopt HIST_IGNORE_DUPS
