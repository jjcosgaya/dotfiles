# .bash_profile
LS_COLORS="di=36:ln=35"
export LS_COLORS

# I don't think this is neccessary anymore.
# I think that the pipewire config automatically creates this directory
if test -z "${XDG_RUNTIME_DIR}"; then
	export XDG_RUNTIME_DIR=/tmp/$(id -u)-runtime-dir
	if ! test -d "${XDG_RUNTIME_DIR}"; then
		mkdir -p ${XDG_RUNTIME_DIR}
		chmod 0700 ${XDG_RUNTIME_DIR}
	fi
fi

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc
