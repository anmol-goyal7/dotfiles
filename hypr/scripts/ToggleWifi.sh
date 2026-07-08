#!/bin/bash
# Toggle Wi-Fi on/off and send a notification
# rfkill-based: works with iwd (NetworkManager no longer runs)

if rfkill list wifi | grep -q "Soft blocked: yes"; then
    rfkill unblock wifi
    notify-send -i network-wireless "Wi-Fi" "Turned ON"
else
    rfkill block wifi
    notify-send -i network-wireless-offline "Wi-Fi" "Turned OFF"
fi
