# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Default applications. The XDG file associations live in
# ~/.config/mimeapps.list; these variables are for terminal programs.
export EDITOR=nvim
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export SUDO_EDITOR="$EDITOR"
export BROWSER=brave-browser
export TERMINAL=wezterm

# Shared colors for ls and lsd (both read LS_COLORS for file types) — matched to the prompt palette:
#   dirs cyan, symlinks magenta, exec green, pipes yellow, sockets magenta,
#   devices yellow, broken/missing symlinks red
LS_COLORS="di=36:ln=35:ex=32:pi=33:so=35:bd=33:cd=33:or=31:mi=31"
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
alias fcd='dir=$(FZF_DEFAULT_COMMAND="fd . ~ --no-ignore --type d 2>/dev/null" fzf) && cd "$dir"'
alias fpdf='pdf=$(FZF_DEFAULT_COMMAND="fd . ~ -e pdf -t f --no-ignore 2>/dev/null" fzf --preview="pdftotext {} - | head -50") && (zathura "$pdf" &)'

# Systemd power controls (polkit authorizes active local sessions without sudo).
alias poweroff='systemctl poweroff'
alias reboot='systemctl reboot'
alias shutdown='systemctl poweroff'
alias halt='systemctl halt'
alias suspend='systemctl suspend'
alias hibernate='systemctl hibernate'
alias hybrid-sleep='systemctl hybrid-sleep'
alias suspend-then-hibernate='systemctl suspend-then-hibernate'

set -o vi

# GnuPG: use the terminal pinentry from interactive shells. The graphical
# password launcher overrides this with PINENTRY_USER_DATA=gui.
if [[ -t 1 ]]; then
  export GPG_TTY="$(tty)"
  export PINENTRY_USER_DATA=tty
  gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 || true
fi

# Prefix based history search
bind -m vi-command '"k": history-search-backward'
bind -m vi-command '"j": history-search-forward'
bind -m vi-insert '"\e[A": history-search-backward'
bind -m vi-insert '"\e[B": history-search-forward'

# pfetch
. "$HOME/.cargo/env"
