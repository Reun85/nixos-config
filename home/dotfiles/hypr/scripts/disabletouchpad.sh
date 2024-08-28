#!/usr/bin/bash
# # prefix device_name with device: and suffix with :enabled
# device_name=$(hyprctl devices | rg "touchpad" | awk '{$1=$1;printf("device:%s:enabled",$1)}')
# # Get current status and switch state
# new_status=$(hyprctl getoption "$device_name" | awk -F': ' '/int/{if ($2 == "1") print "0"; else if ($2 == "0") print "1"}')
# hyprctl keyword "$device_name" "$new_status"
# if [[ $new_status == "1" ]]; then
# 	notify-send "Touchpad has been enabled"
# else
# 	notify-send "Touchpad has been disabled"
# fi
#!/usr/bin/env bash

STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

enable_keyboard() {
	printf "true" >"$STATUS_FILE"
	notify-send -u normal "Enabled touchpad"
	hyprctl keyword '$TOUCHPAD_ENABLED' "true" -r
}

disable_keyboard() {
	printf "false" >"$STATUS_FILE"
	notify-send -u normal "Disabled touchpad"
	hyprctl keyword '$TOUCHPAD_ENABLED' "false" -r
}

if ! [ -f "$STATUS_FILE" ]; then
	disable_keyboard

else
	if [ $(cat "$STATUS_FILE") = "true" ]; then
		disable_keyboard
	elif [ $(cat "$STATUS_FILE") = "false" ]; then
		enable_keyboard
	fi
fi
