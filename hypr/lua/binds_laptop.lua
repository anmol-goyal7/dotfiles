-- Laptop keys: ASUS hardware buttons, brightness, touchpad.
-- The touchpad device block itself is in lua/settings.lua.

local util = require("lua.util")
local apps = require("lua.apps")
local bind, exec, mod = util.bind, util.exec, util.mod

local S = apps.scripts

-- Brightness keys live in lua/hwkeys.lua, bound from lua/binds.lua.
exec("XF86TouchpadToggle", S .. "/TouchPad.sh", { desc = "toggle touchpad" })

-- ASUS Armoury keys
exec("XF86Launch1", "rog-control-center",  { desc = "ROG Control Center" })
exec("XF86Launch3", "asusctl led-mode -n", { desc = "next keyboard RGB profile" })
exec("XF86Launch4", "asusctl profile -n",  { desc = "next fan profile" })

-- Screenshots on F6, for the keyboards with no PrtSc.
-- Super+F6 and Super+Shift+F6 are not here: lua/binds_user.lua gives them to
-- Bluetooth. Super+Shift+S and Super+Print are the everyday screenshot keys.
exec(mod .. " + CTRL + F6", S .. "/ScreenShot.sh --in5",    { desc = "screenshot in 5s" })
exec(mod .. " + ALT + F6",  S .. "/ScreenShot.sh --in10",   { desc = "screenshot in 10s" })
exec("ALT + F6",            S .. "/ScreenShot.sh --active", { desc = "screenshot active window" })

-- Lid switch handling is off: hypridle and the OLED blanking cover it. The
-- monitor-disable variants are in legacy-conf/UserConfigs/Laptops.conf.
