-- Commands run once when the session comes up.
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
--
-- No wallpaper daemon: misc.background_color in lua/settings.lua paints the
-- desktop flat black, which is what an OLED panel wants.

local apps = require("lua.apps")

hl.on("hyprland.start", function()
    -- Hand the session environment to systemd and dbus.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Drop-down terminal (Super+Shift+Return toggles it).
    hl.exec_cmd(apps.scripts .. "/Dropterminal.sh kitty &")

    -- Polkit agent.
    hl.exec_cmd(apps.scripts .. "/Polkit.sh")

    -- Notifications.
    hl.exec_cmd("swaync")

    -- Bar. Killed first so a reload does not leave two running.
    hl.exec_cmd("bash -c 'pkill waybar; sleep 0.2 && waybar'")

    -- OLED pixel-shift: nudges waybar's contents 0-3px every 10 min so the
    -- clock and tray icons do not sit on the same subpixels all uptime. Seeds
    -- waybar/shift.css, which style.css @imports and cannot start without.
    hl.exec_cmd("waybar-pixelshift")

    -- Quickshell (overview, Super+A).
    hl.exec_cmd("qs")

    -- Clipboard history.
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Idle handling: dim, lock, dpms, suspend.
    hl.exec_cmd("hypridle")
end)
