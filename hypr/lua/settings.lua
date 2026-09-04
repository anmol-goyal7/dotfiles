-- Behaviour: layouts, input, misc.
-- https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        layout           = "dwindle",
        resize_on_border = true,
    },

    dwindle = {
        preserve_split       = true,
        special_scale_factor = 0.8,
    },

    master = {
        new_status = "master",
        new_on_top = true,
        mfact      = 0.5,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        repeat_rate  = 50,
        repeat_delay = 300,

        sensitivity       = 0,
        numlock_by_default = true,
        left_handed       = false,
        follow_mouse      = 1,

        touchpad = {
            disable_while_typing   = true,
            natural_scroll         = true,
            clickfinger_behavior   = false,
            middle_button_emulation = false,
            tap_to_click           = true,
            drag_lock              = 0,
        },

        touchdevice = { enabled = true },

        tablet = {
            transform   = 0,
            left_handed = false,
        },
    },

    gestures = {
        workspace_swipe_distance           = 500,
        workspace_swipe_invert             = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio       = 0.5,
        workspace_swipe_create_new         = true,
        workspace_swipe_forever            = true,
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        -- OLED: paint the desktop flat black rather than lighting a wallpaper.
        background_color         = "rgb(000000)",
        vrr                      = 2,
        mouse_move_enables_dpms  = true,
        enable_swallow           = false,
        swallow_regex            = "^(kitty)$",
        focus_on_activate        = false,
        initial_workspace_tracking = 0,
        middle_click_paste       = false,
        enable_anr_dialog        = true,
        anr_missed_pings         = 15,   -- default of 1 fires on any slow app
        allow_session_lock_restore = true,
    },

    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles   = true,
        pass_mouse_when_bound    = false,
    },

    -- Helps XWayland apps not look pixelated under monitor scaling.
    xwayland = {
        enabled            = true,
        force_zero_scaling = true,
    },

    render = { direct_scanout = 0 },

    cursor = {
        sync_gsettings_theme      = true,
        no_hardware_cursors       = 2,   -- 2 = auto; 1 disables them outright
        enable_hyprcursor         = true,
        warp_on_change_workspace  = 2,
        no_warps                  = true,
    },
})

-- 3-finger horizontal swipe switches workspaces.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Touchpad. `hyprctl devices` prints the name.
hl.device({
    name    = "asue1209:00-04f3:319f-touchpad",
    enabled = true,
})
