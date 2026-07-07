#!/bin/bash
# Toggle airplane mode (kills wifi + bluetooth together)

wifi=$(nmcli radio wifi)
bt=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [[ "$wifi" == "enabled" ]] || [[ "$bt" == "yes" ]]; then
    nmcli radio wifi off
    bluetoothctl power off
    notify-send -i airplane-mode "Airplane Mode" "ON — Wi-Fi and Bluetooth disabled"
else
    nmcli radio wifi on
    bluetoothctl power on
    notify-send -i airplane-mode-disabled "Airplane Mode" "OFF — Wi-Fi and Bluetooth enabled"
fi
