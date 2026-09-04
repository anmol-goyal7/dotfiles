-- Decorations and animations -- Tokyo Night on OLED.
-- Blur and shadows stay off: this panel is real OLED, so flat black costs
-- nothing to draw and everything to light up.

hl.config({
    general = {
        border_size = 2,
        gaps_in     = 2,
        gaps_out    = 4,

        col = {
            active_border   = "rgba(7aa2f7cc)",
            inactive_border = "rgba(15161eff)",
        },
    },

    decoration = {
        rounding = 8,

        active_opacity     = 1.0,
        inactive_opacity   = 1.0,
        fullscreen_opacity = 1.0,

        blur   = { enabled = false },
        shadow = { enabled = false },
    },

    group = {
        col = { border_active = "rgba(7aa2f7cc)" },
        groupbar = {
            font_size  = 12,
            height     = 20,
            text_color = "rgba(c0caf5ff)",
            col = {
                active   = "rgba(7aa2f7cc)",
                inactive = "rgba(0a0a0fff)",
            },
        },
    },

    animations = { enabled = true },
})

-- Curves
hl.curve("ease",    { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("easeOut", { type = "bezier", points = { { 0.0, 0.0 },  { 0.2, 1.0 } } })
hl.curve("easeIn",  { type = "bezier", points = { { 0.4, 0.0 },  { 1.0, 1.0 } } })
hl.curve("snappy",  { type = "bezier", points = { { 0.2, 0.9 },  { 0.3, 1.0 } } })
hl.curve("liner",   { type = "bezier", points = { { 1, 1 },      { 1, 1 } } })

hl.animation({ leaf = "windows",       enabled = true, speed = 4, bezier = "snappy",  style = "slide" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 3, bezier = "easeOut", style = "slide" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 2, bezier = "easeIn",  style = "slide" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 3, bezier = "snappy",  style = "slide" })
hl.animation({ leaf = "border",        enabled = true, speed = 2, bezier = "liner" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3, bezier = "easeOut" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 4, bezier = "snappy",  style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 3, bezier = "easeOut", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3, bezier = "easeIn",  style = "slide" })

-- hypr/scripts/Animations.sh (Super+Shift+A) drops a preset here. Optional --
-- with no preset installed the defaults above stand.
pcall(require, "lua.animations")
