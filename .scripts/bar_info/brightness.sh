#!/bin/bash
### BRIGHTNESS ###
dir="/sys/class/backlight"
device=$(ls "$dir" | head -n 1)
brightness=$(<"$dir/$device/brightness")
max=$(<"$dir/$device/max_brightness")
percentage=$((brightness * 100 / max))

if [ $percentage -lt 10 ]; then
	brightness_icon="󱩎 "	
elif [ $percentage -lt 20 ]; then
	brightness_icon="󱩏 "	
elif [ $percentage -lt 30 ]; then
	brightness_icon="󱩐 "	
elif [ $percentage -lt 40 ]; then
	brightness_icon="󱩑 "	
elif [ $percentage -lt 50 ]; then
	brightness_icon="󱩒 "	
elif [ $percentage -lt 60 ]; then
	brightness_icon="󱩓 "	
elif [ $percentage -lt 70 ]; then
	brightness_icon="󱩔 "	
elif [ $percentage -lt 80 ]; then
	brightness_icon="󱩕 "	
elif [ $percentage -lt 90 ]; then
	brightness_icon="󱩖 "	
else
	brightness_icon="󰛨 "	
fi

brightness="$brightness_icon$percentage"

### PRINT ###
printf "%s\n" "$brightness"
