-- Default keybinds.
-- https://wiki.hypr.land/Configuring/Basics/Binds/
--
-- Loaded before lua/binds_laptop.lua and lua/binds_user.lua; those two may
-- override or hl.unbind anything here.

local util = require("lua.util")
local apps = require("lua.apps")
local bind, exec, mod = util.bind, util.exec, util.mod

local S = apps.scripts

-- ---- session ---------------------------------------------------------------
bind("CTRL + ALT + Delete", hl.dsp.exit(),                        { desc = "exit Hyprland" })
bind(mod .. " + Q",         hl.dsp.window.close(),                { desc = "close window" })
exec(mod .. " + SHIFT + Q", S .. "/KillActiveProcess.sh",         { desc = "kill the window's process" })
exec("CTRL + ALT + L",      S .. "/LockScreen.sh",                { desc = "lock screen" })
exec("CTRL + ALT + P",      S .. "/Wlogout.sh",                   { desc = "power menu" })
exec(mod .. " + SHIFT + N", "swaync-client -t -sw",               { desc = "notification panel" })
exec(mod .. " + SHIFT + E", S .. "/Kool_Quick_Settings.sh",       { desc = "KooL settings menu" })

-- ---- layouts ---------------------------------------------------------------
-- Master layout
bind(mod .. " + CTRL + D",      hl.dsp.layout("removemaster"),  { desc = "master: remove from master" })
bind(mod .. " + I",             hl.dsp.layout("addmaster"),     { desc = "master: add to master" })
bind(mod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"), { desc = "master: swap with master" })

-- Dwindle layout
bind(mod .. " + SHIFT + I", hl.dsp.layout("togglesplit"),   { desc = "dwindle: toggle split" })

-- Either layout
bind(mod .. " + M", hl.dsp.layout("splitratio 0.3"), { desc = "widen the split" })

-- Groups (tabbed windows)
bind(mod .. " + G",         hl.dsp.group.toggle(), { desc = "toggle group" })
bind(mod .. " + CTRL + Tab", hl.dsp.group.next(),  { desc = "next window in group" })

-- Cycle floating windows, raising whatever we land on.
bind("ALT + Tab", hl.dsp.window.cycle_next(),   { desc = "cycle windows" })
bind("ALT + Tab", hl.dsp.window.bring_to_top())

-- ---- hardware keys ---------------------------------------------------------
-- Shared with the zen submap; see lua/hwkeys.lua.
for _, k in ipairs(require("lua.hwkeys")) do
    exec(k[1], k[2], k[3])
end

-- ---- screenshots -----------------------------------------------------------
-- Super+Print and Super+Shift+Print live in lua/binds_user.lua (hyprshot).
exec(mod .. " + CTRL + Print",         S .. "/ScreenShot.sh --in5",  { desc = "screenshot in 5s" })
exec(mod .. " + CTRL + SHIFT + Print", S .. "/ScreenShot.sh --in10", { desc = "screenshot in 10s" })
exec("ALT + Print",                    S .. "/ScreenShot.sh --active", { desc = "screenshot active window" })

-- ---- window geometry -------------------------------------------------------
local ARROWS = { left = "l", right = "r", up = "u", down = "d" }
local RESIZE = {
    left  = { x = -50, y = 0 }, right = { x = 50, y = 0 },
    up    = { x = 0, y = -50 }, down  = { x = 0, y = 50 },
}

for key, dir in pairs(ARROWS) do
    bind(mod .. " + SHIFT + " .. key, hl.dsp.window.resize(RESIZE[key]), { repeating = true, desc = "resize window " .. key })
    bind(mod .. " + CTRL + " .. key,  hl.dsp.window.move({ direction = dir }), { desc = "move window " .. key })
    bind(mod .. " + ALT + " .. key,   hl.dsp.window.swap({ direction = dir }), { desc = "swap window " .. key })
    bind(mod .. " + " .. key,         hl.dsp.focus({ direction = dir }),       { desc = "focus " .. key })
end

-- ---- workspaces ------------------------------------------------------------
bind(mod .. " + Tab",           hl.dsp.focus({ workspace = "m+1" }), { desc = "next workspace on monitor" })
bind(mod .. " + SHIFT + Tab",   hl.dsp.focus({ workspace = "m-1" }), { desc = "previous workspace on monitor" })

bind(mod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }), { desc = "send to scratchpad" })
bind(mod .. " + U",         hl.dsp.workspace.toggle_special(),            { desc = "toggle scratchpad" })

-- The number row. The old .conf bound these by keycode (code:10 .. code:19) so
-- the digits would stay put under a non-US layout; the Lua parser accepts the
-- "code:NN" spelling but stores no key for it, so the bind never fires. Layout
-- is us with no alternates (lua/settings.lua), so bind the symbols instead.
for i = 1, 10 do
    local key = tostring(i % 10)
    bind(mod .. " + " .. key,           hl.dsp.focus({ workspace = i }),                      { desc = "workspace " .. key })
    bind(mod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }),                { desc = "move to workspace " .. key })
    bind(mod .. " + CTRL + " .. key,    hl.dsp.window.move({ workspace = i, silent = true }), { desc = "move to workspace " .. key .. " silently" })
end

bind(mod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "-1" }), { desc = "move to previous workspace" })
bind(mod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }), { desc = "move to next workspace" })
bind(mod .. " + CTRL + bracketleft",   hl.dsp.window.move({ workspace = "-1", silent = true }), { desc = "move to previous workspace silently" })
bind(mod .. " + CTRL + bracketright",  hl.dsp.window.move({ workspace = "+1", silent = true }), { desc = "move to next workspace silently" })

bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { desc = "next workspace" })
bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { desc = "previous workspace" })
bind(mod .. " + period",     hl.dsp.focus({ workspace = "e+1" }), { desc = "next workspace" })
bind(mod .. " + comma",      hl.dsp.focus({ workspace = "e-1" }), { desc = "previous workspace" })

-- ---- mouse -----------------------------------------------------------------
bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, desc = "drag window" })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, desc = "resize window with mouse" })
