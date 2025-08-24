#!/bin/bash
### VOLUME ###
volume_value=$(pamixer --get-volume)
if [ "$(pamixer --get-mute)" = false ]; then
	if [ $volume_value -lt 33 ]; then
		volume_icon="󰕿 "
	elif [ $volume_value -lt 66 ]; then
		volume_icon="󰖀 "
	else
		volume_icon="󰕾 "
	fi
	volume="$volume_icon$volume_value"
else
    	   volume="󰖁 $volume_value"
fi

### PRINT ###
printf "%s\n" "$volume"
