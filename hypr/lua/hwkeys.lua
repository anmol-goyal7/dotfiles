-- Hardware keys: volume, media, brightness, radios, sleep.
--
-- One list, used twice. lua/binds.lua and lua/binds_laptop.lua bind these
-- normally; lua/submaps.lua re-binds the same list inside the zen submap,
-- which is what keeps volume and brightness working while zen has every other
-- global bind switched off. Retyping them there would let the two drift.

local apps = require("lua.apps")
local S = apps.scripts

return {
    -- audio
    { "XF86AudioRaiseVolume", S .. "/Volume.sh --inc",        { desc = "volume up",   locked = true, repeating = true } },
    { "XF86AudioLowerVolume", S .. "/Volume.sh --dec",        { desc = "volume down", locked = true, repeating = true } },
    { "XF86AudioMute",        S .. "/Volume.sh --toggle",     { desc = "mute",     locked = true } },
    { "XF86AudioMicMute",     S .. "/Volume.sh --toggle-mic", { desc = "mute mic", locked = true } },

    -- media. There is no XF86AudioPlayPause keysym; the old .conf bound it
    -- anyway and it never fired.
    { "XF86AudioPlay", S .. "/MediaCtrl.sh --pause", { desc = "play/pause", locked = true } },
    { "XF86AudioPause", S .. "/MediaCtrl.sh --pause", { desc = "play/pause", locked = true } },
    { "XF86AudioNext", S .. "/MediaCtrl.sh --nxt",   { desc = "next track", locked = true } },
    { "XF86AudioPrev", S .. "/MediaCtrl.sh --prv",   { desc = "previous track", locked = true } },
    { "XF86AudioStop", S .. "/MediaCtrl.sh --stop",  { desc = "stop", locked = true } },

    -- brightness
    { "XF86MonBrightnessDown", S .. "/Brightness.sh --dec",    { desc = "screen brightness down", locked = true, repeating = true } },
    { "XF86MonBrightnessUp",   S .. "/Brightness.sh --inc",    { desc = "screen brightness up",   locked = true, repeating = true } },
    { "XF86KbdBrightnessDown", S .. "/BrightnessKbd.sh --dec", { desc = "keyboard backlight down", locked = true, repeating = true } },
    { "XF86KbdBrightnessUp",   S .. "/BrightnessKbd.sh --inc", { desc = "keyboard backlight up",   locked = true, repeating = true } },

    -- system
    { "XF86Sleep",  "systemctl suspend",     { desc = "sleep", locked = true } },
    { "XF86Rfkill", S .. "/AirplaneMode.sh", { desc = "airplane mode", locked = true } },
}
