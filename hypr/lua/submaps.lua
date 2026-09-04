-- Submaps: resize, and the zen lock.
-- https://wiki.hypr.land/Configuring/Binds/#submaps

local util = require("lua.util")
local apps = require("lua.apps")
local bind, exec, mod = util.bind, util.exec, util.mod

local S   = apps.scripts
local BIN = apps.dotbin

-- Border colours, so the screen says which mode is on.
NORMAL_BORDER = "rgba(7aa2f7cc)"   -- matches lua/look.lua
RESIZE_BORDER = "rgba(f7768eff)"
ZEN_BORDER    = "rgba(bb9af7ff)"

local function set_border(colour)
    hl.config({ general = { col = { active_border = colour } } })
end

-- ---------------------------------------------------------------------------
-- Resize mode -- Super+R, then hjkl. Escape leaves.
-- ---------------------------------------------------------------------------

bind(mod .. " + R", function()
    set_border(RESIZE_BORDER)
    hl.dispatch(hl.dsp.submap("resize"))
end, { desc = "resize mode (hjkl, Esc to leave)" })

util.submap("resize", function()
    local STEP = { l = { x = 10, y = 0 }, h = { x = -10, y = 0 },
                   k = { x = 0, y = -10 }, j = { x = 0, y = 10 } }
    for key, delta in pairs(STEP) do
        bind(key, util.resize_by(delta), { repeating = true, desc = "resize" })
    end
    bind("escape", function()
        set_border(NORMAL_BORDER)
        hl.dispatch(hl.dsp.submap("reset"))
    end, { desc = "leave resize mode" })
end)

-- ---------------------------------------------------------------------------
-- Zen mode -- see bin/zen.
--
-- Entering a submap makes every global bind inactive at once, which is the
-- whole mechanism: only what is declared in here still works. The submap is
-- built here rather than by the script so that a config reload puts it back on
-- its own -- under the old .conf setup the script built it with `hyprctl
-- keyword` and any reload emptied it, which is a lockout with no way out.
--
-- The script adds the border, drops the mouse drag binds and, for a browser,
-- the extra swallowed keys, via ZEN_ARM below.
-- ---------------------------------------------------------------------------

-- Keys that mean "open something new" and that the compositor cannot otherwise
-- see the meaning of. Bound to re-entering the submap already active, so the
-- key is consumed and nothing happens -- no process spawned per keypress.
local ZEN_SWALLOW = { "CTRL + SHIFT + T", "CTRL + SHIFT + N", "ALT + Tab" }

-- Only when the locked window is a browser. In a terminal these are work keys:
-- Ctrl+L clears, Ctrl+N completes in nvim, Ctrl+T is fzf.
local ZEN_SWALLOW_BROWSER = {
    "CTRL + T", "CTRL + N", "CTRL + L", "CTRL + Tab", "CTRL + SHIFT + Tab",
    "CTRL + prior", "CTRL + next",
    "CTRL + 1", "CTRL + 2", "CTRL + 3", "CTRL + 4", "CTRL + 5",
    "CTRL + 6", "CTRL + 7", "CTRL + 8", "CTRL + 9",
}

util.submap("zen", function()
    -- The way out.
    exec(mod .. " + F5", BIN .. "/zen", { desc = "leave zen mode" })

    -- Hardware keys are not a way to get distracted, and the lock screen has
    -- to stay reachable.
    for _, k in ipairs(require("lua.hwkeys")) do
        exec(k[1], k[2], k[3])
    end
    exec("CTRL + ALT + L", S .. "/LockScreen.sh", { desc = "lock screen" })

    for _, k in ipairs(ZEN_SWALLOW) do
        bind(k, hl.dsp.submap("zen"))
    end
end)

---Called by bin/zen over `hyprctl eval`. Puts the mode's runtime half in
---place: border, no mouse dragging, and the browser key swallows.
---Safe to call again after a reload -- that is what re-arming does.
function ZEN_ARM(is_browser)
    if is_browser then
        hl.define_submap("zen", function()
            for _, k in ipairs(ZEN_SWALLOW_BROWSER) do
                hl.bind(k, hl.dsp.submap("zen"))
            end
        end)
    end
    -- The submap already makes these inactive, but a mouse drag is the one
    -- path out that needs no keyboard at all.
    hl.unbind(mod .. " + mouse:272")
    hl.unbind(mod .. " + mouse:273")
    set_border(ZEN_BORDER)
    hl.dispatch(hl.dsp.submap("zen"))
end
