#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -e /home/jota/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jota/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
