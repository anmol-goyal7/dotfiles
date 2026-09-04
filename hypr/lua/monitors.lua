-- Monitors and workspace rules.
-- https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Internal panel: Samsung ATNA40YK11 OLED, 2880x1800, 1728x1080 logical.
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.6666666,
})

-- Anything plugged in later.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Workspace rules: none pinned to a monitor. Examples, if that changes --
--   hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
--   hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "kitty" })
