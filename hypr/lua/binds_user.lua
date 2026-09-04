-- Personal keybinds. Loaded last, so anything here wins.

local util = require("lua.util")
local apps = require("lua.apps")
local bind, exec, mod = util.bind, util.exec, util.mod
local resize_by = util.resize_by

local S    = apps.scripts
local BIN  = apps.dotbin
local HOME = apps.home

-- ---------------------------------------------------------------------------
-- Screenshots and OCR
-- ---------------------------------------------------------------------------
local SHOTS = HOME .. "/Pictures/Screenshots"

exec(mod .. " + SHIFT + S",     'hyprshot -m region -z -o "' .. SHOTS .. '"', { desc = "screenshot region" })
exec(mod .. " + SHIFT + Print", 'hyprshot -m window -z -o "' .. SHOTS .. '"', { desc = "screenshot window" })
exec(mod .. " + Print",         'hyprshot -m output -o "' .. SHOTS .. '"',    { desc = "screenshot screen" })

-- Read text off the screen straight into the clipboard.
exec(mod .. " + SHIFT + T",
    'grim -g "$(slurp -d -b 00000000 -c 00ff00ff -w 2)" - | tesseract - - | wl-copy',
    { desc = "OCR a region to the clipboard" })

-- ---------------------------------------------------------------------------
-- Trackpad-less window handling: vim motions
-- ---------------------------------------------------------------------------
local VIM = { h = "l", l = "r", k = "u", j = "d" }
local VIM_RESIZE = {
    h = { x = -50, y = 0 }, l = { x = 50, y = 0 },
    k = { x = 0, y = -50 }, j = { x = 0, y = 50 },
}

for key, dir in pairs(VIM) do
    bind(mod .. " + " .. key,           hl.dsp.focus({ direction = dir }),          { desc = "focus " .. dir })
    bind(mod .. " + SHIFT + " .. key,   resize_by(VIM_RESIZE[key]),                 { repeating = true, desc = "resize window " .. dir })
    bind(mod .. " + CTRL + " .. key,    hl.dsp.window.move({ direction = dir }),    { desc = "move window " .. dir })
end

-- ---------------------------------------------------------------------------
-- Pointer from the keyboard
-- ---------------------------------------------------------------------------
exec(mod .. " + CTRL + SPACE", "ydotool click 0xC0", { desc = "left click" })
exec(mod .. " + CTRL + x",     "ydotool click 0xC1", { desc = "right click" })

-- Super+Ctrl+M: type the letters shown over the screen to narrow to a point;
-- the cursor warps there and clicks. Escape leaves the cursor put and does not
-- click. Pair with Super+Ctrl+x for a right click.
exec(mod .. " + CTRL + M", "wl-kbptr && ydotool click 0xC0", { desc = "click anywhere (wl-kbptr)" })

-- ---------------------------------------------------------------------------
-- Launchers and window state
-- ---------------------------------------------------------------------------
exec(mod .. " + SPACE",
    "pkill rofi || rofi -show drun -theme " .. HOME .. "/.config/rofi/themes/tokyonight-oled.rasi",
    { desc = "app launcher" })

bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }),      { desc = "toggle floating" })
bind(mod .. " + ALT + F",   hl.dsp.window.fullscreen(),                      { desc = "fullscreen" })
bind(mod .. " + CTRL + F",  hl.dsp.window.fullscreen({ mode = "maximized" }), { desc = "maximise (fake fullscreen)" })

-- Float or tile everything on this workspace at once. `workspaceopt allfloat`
-- is gone in 0.56, so do it a window at a time: if anything is still tiled,
-- float the lot, otherwise put the lot back.
bind(mod .. " + ALT + SPACE", function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local wins = hl.get_workspace_windows(ws)
    local any_tiled = false
    for _, w in ipairs(wins) do
        if not w.floating then any_tiled = true break end
    end
    for _, w in ipairs(wins) do
        if w.floating ~= any_tiled then
            hl.dispatch(hl.dsp.window.float({ action = "toggle", window = "address:" .. w.address }))
        end
    end
end, { desc = "float / tile the whole workspace" })

bind(mod .. " + V", hl.dsp.layout("togglesplit"), { desc = "toggle split direction" })

-- ---------------------------------------------------------------------------
-- Focus modes
-- ---------------------------------------------------------------------------
exec(mod .. " + F",         BIN .. "/dsa",       { desc = "DSA mode: Claude | NeetCode | terminal" })
exec(mod .. " + SHIFT + D", BIN .. "/dsa close", { desc = "close DSA mode" })
exec(mod .. " + F5",        BIN .. "/zen",       { desc = "zen mode: lock onto this window" })
exec(mod .. " + slash",     "pkill rofi || " .. BIN .. "/keys", { desc = "keybind cheatsheet" })

-- ---------------------------------------------------------------------------
-- Apps
-- ---------------------------------------------------------------------------
exec(mod .. " + Return", apps.term,    { desc = "terminal" })
exec(mod .. " + E",      apps.files,   { desc = "file manager" })
exec(mod .. " + B",      apps.browser, { desc = "browser" })
exec(mod .. " + D",      "brave",      { desc = "Brave" })
exec(mod .. " + P",      "zapzap",     { desc = "WhatsApp" })
bind(mod .. " + A",      hl.dsp.global("quickshell:overviewToggle"), { desc = "overview" })

exec(mod .. " + SHIFT + Return", S .. "/Dropterminal.sh " .. apps.term, { desc = "drop-down terminal" })

-- TUIs
exec(mod .. " + ALT + G", "kitty --class lazygit -e lazygit", { desc = "lazygit" })
exec(mod .. " + ALT + T", "kitty --class btop -e btop",       { desc = "btop" })

-- ---------------------------------------------------------------------------
-- Menus and helpers
-- ---------------------------------------------------------------------------
exec(mod .. " + CTRL + SHIFT + H", S .. "/KeyHints.sh",       { desc = "help / cheat sheet" })
exec(mod .. " + ALT + R",          S .. "/Refresh.sh",        { desc = "refresh waybar, swaync, rofi" })
exec(mod .. " + ALT + E",          'BEMOJI_PICKER_CMD="wofi -d" bemoji -t', { desc = "emoji picker" })
exec(mod .. " + S",                S .. "/RofiSearch.sh",     { desc = "web search" })
exec(mod .. " + CTRL + S",         "rofi -show window",       { desc = "window switcher" })
exec(mod .. " + ALT + O",          S .. "/ChangeBlur.sh",     { desc = "cycle blur" })
exec(mod .. " + SHIFT + G",        S .. "/GameMode.sh",       { desc = "toggle game mode" })
exec(mod .. " + ALT + L",          S .. "/ChangeLayout.sh",   { desc = "switch dwindle / master" })
exec(mod .. " + CTRL + R",         S .. "/RofiThemeSelector.sh", { desc = "rofi theme" })
exec(mod .. " + CTRL + SHIFT + R", "pkill rofi || true && " .. S .. "/RofiThemeSelector-modified.sh", { desc = "rofi theme (alt)" })
exec(mod .. " + CTRL + SHIFT + K", S .. "/KeyBinds.sh",       { desc = "keybind list" })
exec(mod .. " + SHIFT + A",        S .. "/Animations.sh",     { desc = "cycle animations" })

-- Notifications
exec(mod .. " + grave",         "swaync-client -t", { desc = "notification panel" })
exec(mod .. " + SHIFT + grave", "swaync-client -C", { desc = "clear notifications" })

-- Clipboard history
exec(mod .. " + ALT + V", S .. "/ClipManager.sh", { desc = "clipboard history" })

-- Bar
exec(mod .. " + CTRL + ALT + B", "pkill -SIGUSR1 waybar", { desc = "toggle waybar" })

-- Keyboard layout switching. non_consuming so the modifier still reaches apps.
-- The modifier goes by its plain name (ALT, SHIFT); only the key half takes
-- the _L suffix. "ALT_L + SHIFT_L" parses but leaves the bind with no modifier.
local LAYOUT = { locked = true, non_consuming = true }
exec("ALT + SHIFT_L", S .. "/SwitchKeyboardLayout.sh",   LAYOUT)
exec("SHIFT + ALT_L", S .. "/Tak0-Per-Window-Switch.sh", LAYOUT)

-- Transparency toggle. `hyprctl setprop` has been a dead request since 0.56;
-- the Lua dispatcher is the working way in.
bind(mod .. " + CTRL + O", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }),
    { desc = "toggle window opacity" })

-- Red screen tint. hyprsunset and wlsunset are not installed; bin/red is a
-- screen shader. Same thing the `red` / `blue` commands do.
exec(mod .. " + N", BIN .. "/red toggle", { desc = "red tint on/off" })

-- ---------------------------------------------------------------------------
-- Desktop zoom
-- ---------------------------------------------------------------------------
local function zoom_by(factor)
    return function()
        local f = tonumber(hl.get_config("cursor.zoom_factor")) or 1
        if f < 1 then f = 1 end
        hl.config({ cursor = { zoom_factor = f * factor } })
    end
end

bind(mod .. " + ALT + mouse_down", zoom_by(2.0),  { desc = "zoom in" })
bind(mod .. " + ALT + mouse_up",   zoom_by(0.5),  { desc = "zoom out" })
bind(mod .. " + ALT + equal",      zoom_by(1.5),  { desc = "zoom in" })
bind(mod .. " + ALT + minus",      zoom_by(1/1.5), { desc = "zoom out" })
bind(mod .. " + ALT + 0", function() hl.config({ cursor = { zoom_factor = 1 } }) end,
    { desc = "reset zoom" })

-- ---------------------------------------------------------------------------
-- Workspaces across monitors
-- ---------------------------------------------------------------------------
for key, dir in pairs({ F9 = "l", F10 = "r", F11 = "u", F12 = "d" }) do
    bind(mod .. " + CTRL + " .. key, hl.dsp.workspace.move({ monitor = dir }),
        { desc = "move workspace to the monitor " .. dir })
end

-- ---------------------------------------------------------------------------
-- Power modes
-- ---------------------------------------------------------------------------
exec(mod .. " + F1",         "kitty --class power-saver -e saver",             { desc = "power: battery saver" })
exec(mod .. " + F2",         "kitty --class power-balance -e balance",         { desc = "power: balanced" })
exec(mod .. " + F3",         "kitty --class power-performance -e performance", { desc = "power: performance" })
exec(mod .. " + F4",         "kitty --class power-game -e game",               { desc = "power: game" })
exec(mod .. " + SHIFT + F4", "kitty --class power-status -e powermode",        { desc = "power: show mode" })

-- ---------------------------------------------------------------------------
-- Radios and audio -- no mouse needed
-- ---------------------------------------------------------------------------
-- Wi-Fi (F5 belongs to zen mode, so the toggle sits on F9)
exec(mod .. " + F9",         S .. "/ToggleWifi.sh",         { desc = "Wi-Fi on/off" })
exec(mod .. " + SHIFT + F5", "kitty --class impala -e impala", { desc = "Wi-Fi (impala)" })
exec(mod .. " + CTRL + W",   "kitty --class impala -e impala", { desc = "Wi-Fi (impala)" })

-- Bluetooth. LaunchBluetui.sh works around TLP rfkill-blocking the adapter at
-- every boot, which makes bluetui exit instantly.
exec(mod .. " + F6",         S .. "/ToggleBluetooth.sh", { desc = "Bluetooth on/off" })
exec(mod .. " + SHIFT + F6", "kitty --class bluetui -e " .. S .. "/LaunchBluetui.sh", { desc = "Bluetooth (bluetui)" })
exec(mod .. " + CTRL + B",   "kitty --class bluetui -e " .. S .. "/LaunchBluetui.sh", { desc = "Bluetooth (bluetui)" })

-- Audio
exec(mod .. " + F7",         "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { desc = "mute" })
exec(mod .. " + SHIFT + F7", "pavucontrol",                                { desc = "audio mixer" })

-- Airplane mode kills Wi-Fi and Bluetooth together.
exec(mod .. " + F8", S .. "/ToggleAirplane.sh", { desc = "airplane mode" })

-- Cloudflare WARP
exec(mod .. " + W", apps.localbin .. "/warp-toggle", { desc = "Cloudflare WARP on/off" })
