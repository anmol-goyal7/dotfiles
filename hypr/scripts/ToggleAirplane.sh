#!/bin/bash
# Toggle airplane mode (kills wifi + bluetooth together)
# rfkill-based: works with iwd (NetworkManager no longer runs)

wifi_on=$(rfkill list wifi | grep -c "Soft blocked: no")
bt_on=$(bluetoothctl show | grep -c "Powered: yes")

if [ "$wifi_on" -gt 0 ] || [ "$bt_on" -gt 0 ]; then
    rfkill block wifi
    rfkill block bluetooth
    notify-send -i airplane-mode "Airplane Mode" "ON — Wi-Fi and Bluetooth disabled"
else
    rfkill unblock wifi
    rfkill unblock bluetooth
    sleep 0.5   # bluetoothd auto-powers on unblock; explicit power-on races with it
    bluetoothctl show | grep -q "Powered: yes" || bluetoothctl power on
    notify-send -i airplane-mode-disabled "Airplane Mode" "OFF — Wi-Fi and Bluetooth enabled"
fi
