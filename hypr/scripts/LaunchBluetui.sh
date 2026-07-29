#!/bin/bash
# Launch bluetui, clearing TLP's boot-time rfkill soft-block first.
# TLP sets DEVICES_TO_DISABLE_ON_STARTUP="bluetooth" (/etc/tlp.d/01-battery-optimize.conf),
# so the adapter is blocked every boot and bluetui exits instantly against it.

rfkill unblock bluetooth
sleep 0.5   # bluetoothd auto-powers on unblock; explicit power-on races with it
bluetoothctl show | grep -q "Powered: yes" || bluetoothctl power on

exec bluetui
