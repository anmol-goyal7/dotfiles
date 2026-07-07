#!/bin/bash
# Toggle Wi-Fi on/off and send a notification

if nmcli radio wifi | grep -q "enabled"; then
    nmcli radio wifi off
    notify-send -i network-wireless-offline "Wi-Fi" "Turned OFF"
else
    nmcli radio wifi on
    notify-send -i network-wireless "Wi-Fi" "Turned ON"
fi
