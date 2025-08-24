#!/bin/bash
### NOTIFICATION TEMP FILES ###
notified_10="/tmp/battery_notified_10"
notified_5="/tmp/battery_notified_5"

### BATTERY ###
batteries=(/sys/class/power_supply/BAT*)

total_capacity=0
battery_count=0
charging=false

for bat in "${batteries[@]}"; do
	capacity=$(<"$bat/capacity")
	total_capacity=$((total_capacity + capacity))
	battery_count=$((battery_count + 1))

	status=$(<"$bat/status")
	if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
		charging=true
	fi
done


battery_value=$((total_capacity / battery_count))
if [ $battery_value -lt 5 ]; then
	battery_icon=" "	
	if [ ! -e "$notified_5" ]; then
		notify-send " Battery really low!"
		touch "$notified_5"
	fi
elif [ $battery_value -lt 10 ]; then
	if [ ! -e "$notified_10" ]; then
		notify-send " Battery low!"
		touch "$notified_10"
	fi
	if [ -e "$notified_5" ]; then
		rm "$notified_5"
	fi
	battery_icon=" "	
elif [ $battery_value -lt 25 ]; then
	if [ -e "$notified_10" ]; then
		rm "$notified_10"
	fi
	battery_icon=" "	
elif [ $battery_value -lt 50 ]; then
	battery_icon=" "	
elif [ $battery_value -lt 75 ]; then
	battery_icon=" "	
else
	battery_icon=" "	
fi

if $charging; then
	battery_icon=" "
fi

battery="$battery_icon$battery_value%"

### PRINT ###
printf "%s\n" "$battery"

# Icons
# 󰕿
# 󰖀
# 󰕾
# 󰸈
# 
# 
# 
# 
# 
#
# 󰹐
# 󱩎
# 󱩏
# 󱩐
# 󱩑
# 󱩒
# 󱩓
# 󱩔
# 󱩕
# 󱩖
# 󰛨
# 
