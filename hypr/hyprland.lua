-- =============================================================================
-- HYPRLAND
--
-- Lua config. Hyprland 0.56 deprecated the .conf format and 0.57 drops it, so
-- everything that used to live in hyprland.conf + configs/ + UserConfigs/ is
-- now under lua/. The old tree is kept verbatim in legacy-conf/ for reference.
--
-- Two things changed for anything that talks to Hyprland from a script:
--   * `hyprctl keyword ...`   ->  `hyprctl eval 'hl.config{...}'`
--   * `hyprctl dispatch X Y`  ->  `hyprctl dispatch 'hl.dsp.x.y(...)'`
-- `hyprctl getoption`, `clients`, `monitors`, `devices` and `reload` are
-- unchanged. bin/hlset wraps the first of those for the shell scripts.
--
-- To fall back to the old config: rename this file. Hyprland prefers
-- hyprland.lua over hyprland.conf, so with it gone the .conf tree takes over
-- again -- copy legacy-conf/ back to where it came from first.
-- =============================================================================

require("lua.env")
require("lua.monitors")
require("lua.settings")
require("lua.look")
require("lua.rules")

-- Binds, in order: defaults, then laptop keys, then personal ones. Later files
-- may override or hl.unbind anything an earlier one set.
require("lua.binds")
require("lua.binds_laptop")
require("lua.binds_user")
require("lua.submaps")

-- Last, so nothing it launches races the config.
require("lua.startup")
