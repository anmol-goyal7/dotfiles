#!/bin/bash
# Toggle Bluetooth on/off and send a notification

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    notify-send -i bluetooth-disabled "Bluetooth" "Turned OFF"
else
    bluetoothctl power on
    notify-send -i bluetooth "Bluetooth" "Turned ON"
fi
