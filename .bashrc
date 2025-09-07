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
PROMPT_COMMAND='history -a; history -r' # After every command append to the history file and reload the history.


alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fcd='dir=$(fd . ~ --no-ignore --type d 2>/dev/null | fzf) && cd "$dir"'

# set -o vi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


pfetch
