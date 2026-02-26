# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

LS_COLORS="di=36:ln=35"
PS1='\[\e[36m\]\u\[\e[0m\] \[\e[37m\]{  \w }\[\e[0m\] $(if [ $? -eq 0 ]; then printf "\[\e[32m\]$?"; else printf "\[\e[31m\]$?"; fi)\[\e[0m\]\n\[\e[35m\]\[\e[0m\] '

# Bash history
# This ignores commands that start with space and removes from history any other occurences of the last command.
HISTCONTROL=ignorespace:erasedups
HISTSIZE=1000
HISTFILESIZE=1000
PROMPT_COMMAND="deduplicate_history" # This runs after every command entered in the terminal
deduplicate_history() {
  # Append last command to bash_history
  history -a

  # Remove duplicates from bash_history
  tac ~/.bash_history | awk '!seen[$0]++' | tac > /tmp/bashis.tmp && mv /tmp/bashis.tmp ~/.bash_history

  # Reload session bash history (clear and read from file)
  history -c
  history -r
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# alias fcd='dir=$(fd . ~ --no-ignore --type d 2>/dev/null | fzf) && cd "$dir"'
alias fcd='dir=$(FZF_DEFAULT_COMMAND="fd . ~ --no-ignore --type d 2>/dev/null" fzf) && cd "$dir"'

set -o vi

# Prefix based history search
bind -m vi-command '"k": history-search-backward'
bind -m vi-command '"j": history-search-forward'
bind -m vi-insert '"\e[A": history-search-backward'
bind -m vi-insert '"\e[B": history-search-forward'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# pnpm
export PNPM_HOME="/home/jota/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/.cargo/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

pfetch
. "$HOME/.cargo/env"
