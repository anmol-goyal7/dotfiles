-- Window and layer rules.
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- ---------------------------------------------------------------------------
-- Tags. Apps get grouped under a tag once, and the rules below act on the tag
-- rather than on another copy of the regex.
-- ---------------------------------------------------------------------------

local TAGS = {
    -- browsers
    { "browser", class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$" },
    { "browser", class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" },
    { "browser", class = "^(chrome-.+-Default)$" },  -- Chrome PWAs
    { "browser", class = "^([Cc]hromium)$" },
    { "browser", class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$" },
    { "browser", class = "^(Brave-browser(-beta|-dev|-unstable)?)$" },
    { "browser", class = "^([Tt]horium-browser|[Cc]achy-browser)$" },
    { "browser", class = "^(zen-alpha|zen)$" },

    -- notifications
    { "notif", class = "^(swaync-control-center|swaync-notification-window|swaync-client|class)$" },

    -- KooL menus
    { "KooL_Cheat",    title = "^(KooL Quick Cheat Sheet)$" },
    { "KooL_Settings", title = "^(KooL Hyprland Settings)$" },
    { "KooL-Settings", class = "^(nwg-displays|nwg-look)$" },

    -- terminals
    { "terminal", class = "^(Alacritty|kitty|kitty-dropterm)$" },

    -- email
    { "email", class = "^([Tt]hunderbird|org.gnome.Evolution)$" },
    { "email", class = "^(eu.betterbird.Betterbird)$" },

    -- editors / IDEs
    { "projects", class = "^(codium|codium-url-handler|VSCodium)$" },
    { "projects", class = "^(VSCode|code-url-handler)$" },
    { "projects", class = "^(jetbrains-.+)$" },

    -- screen sharing
    { "screenshare", class = "^(com.obsproject.Studio)$" },

    -- chat
    { "im", class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" },
    { "im", class = "^([Ff]erdium)$" },
    { "im", class = "^([Ww]hatsapp-for-linux)$" },
    { "im", class = "^(ZapZap|com.rtosta.zapzap)$" },
    { "im", class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" },
    { "im", class = "^(teams-for-linux)$" },
    { "im", class = "^(im.riot.Riot|Element)$" },

    -- games and stores
    { "games",     class = "^(gamescope)$" },
    { "games",     class = "^(steam_app_\\d+)$" },
    { "gamestore", class = "^([Ss]team)$" },
    { "gamestore", title = "^([Ll]utris)$" },
    { "gamestore", class = "^(com.heroicgameslauncher.hgl)$" },

    -- file managers
    { "file-manager", class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$" },
    { "file-manager", class = "^(app.drey.Warp)$" },

    -- wallpaper pickers
    { "wallpaper", class = "^([Ww]aytrogen)$" },

    -- media
    { "multimedia",       class = "^([Aa]udacious)$" },
    { "multimedia_video", class = "^([Mm]pv|vlc)$" },

    -- settings-ish dialogs
    { "settings", title = "^(ROG Control)$" },
    { "settings", class = "^(wihotspot(-gui)?)$" },
    { "settings", class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" },
    { "settings", class = "^(gnome-disks|wihotspot(-gui)?)$" },
    { "settings", title = "(Kvantum Manager)" },
    { "settings", class = "^(file-roller|org.gnome.FileRoller)$" },
    { "settings", class = "^(nm-applet|nm-connection-editor|blueman-manager)$" },
    { "settings", class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
    { "settings", class = "^(qt5ct|qt6ct|[Yy]ad)$" },
    { "settings", class = "(xdg-desktop-portal-gtk)" },
    { "settings", class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
    { "settings", class = "^([Rr]ofi)$" },

    -- viewers
    { "viewer", class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" },
    { "viewer", class = "^(evince)$" },
    { "viewer", class = "^(eog|org.gnome.Loupe)$" },
}

for _, t in ipairs(TAGS) do
    hl.window_rule({
        match = { class = t.class, title = t.title },
        tag   = "+" .. t[1],
    })
end

-- ---------------------------------------------------------------------------
-- Rules
-- ---------------------------------------------------------------------------

-- Wi-Fi / Bluetooth TUIs: floating, centred, spotlight-sized.
hl.window_rule({
    name  = "net-tuis",
    match = { class = "^(impala|bluetui)$" },
    float = true, center = true, size = "45% 60%",
})

-- nmtui, when it gets used.
hl.window_rule({
    name  = "nmtui",
    match = { class = "^(nmtui)$" },
    float = true, center = true, size = "50% 60%",
})

-- Video players own their own dimming.
hl.window_rule({ match = { tag = "multimedia_video" }, no_blur = true, opacity = 1.0 })

-- Position
hl.window_rule({ match = { tag = "KooL_Cheat" },   center = true })
hl.window_rule({ match = { tag = "KooL-Settings" }, center = true })
hl.window_rule({ match = { class = "([Tt]hunar)", title = "negative:(.*[Tt]hunar.*)" }, center = true })
hl.window_rule({ match = { title = "^(ROG Control)$" }, center = true })
hl.window_rule({ match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({ match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, center = true })
hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" }, center = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, center = true })

-- Picture-in-Picture parks top-right, pinned, aspect kept.
hl.window_rule({
    name  = "pip",
    match = { title = "^(Picture-in-Picture)$" },
    float = true, pin = true, move = "72% 7%", keep_aspect_ratio = true,
})

-- Do not dim or sleep behind a fullscreen video.
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })

-- Floating
hl.window_rule({ match = { tag = "KooL_Cheat" },    float = true })
hl.window_rule({ match = { tag = "wallpaper" },     float = true })
hl.window_rule({ match = { tag = "settings" },      float = true })
hl.window_rule({ match = { tag = "viewer" },        float = true })
hl.window_rule({ match = { tag = "KooL-Settings" }, float = true })
hl.window_rule({ match = { class = "([Zz]oom|onedriver|onedriver-launcher)$" }, float = true })
hl.window_rule({ match = { class = "(org.gnome.Calculator)", title = "(Calculator)" }, float = true })
hl.window_rule({ match = { class = "^(mpv|com.github.rafostar.Clapper)$" }, float = true })
hl.window_rule({ match = { class = "^([Qq]alculate-gtk)$" }, float = true })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, float = true })

-- Popups and dialogues. The negative: title matchers keep the app's own main
-- window tiled while its dialogues float.
hl.window_rule({ match = { title = "^(Authentication Required)$" }, float = true, center = true })
hl.window_rule({ match = { class = "(codium|codium-url-handler|VSCodium)", title = "negative:(.*codium.*|.*VSCodium.*)" }, float = true })
hl.window_rule({ match = { class = "^(com.heroicgameslauncher.hgl)$", title = "negative:(Heroic Games Launcher)" }, float = true })
hl.window_rule({ match = { class = "^([Ss]team)$", title = "negative:^([Ss]team)$" }, float = true })
hl.window_rule({ match = { class = "([Tt]hunar)", title = "negative:(.*[Tt]hunar.*)" }, float = true })

hl.window_rule({ match = { title = "^(Add Folder to Workspace)$" }, float = true, center = true, size = "70% 60%" })
hl.window_rule({ match = { title = "^(Save As)$" },                 float = true, center = true, size = "70% 60%" })
hl.window_rule({ match = { initial_title = "(Open Files)" },        float = true, size = "70% 60%" })
hl.window_rule({ match = { title = "^(SDDM Background)$" },         float = true, center = true, size = "16% 12%" })

-- Size
hl.window_rule({ match = { tag = "KooL_Cheat" }, size = "65% 90%" })
hl.window_rule({ match = { tag = "wallpaper" },  size = "70% 70%" })
hl.window_rule({ match = { tag = "settings" },   size = "70% 70%" })
hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" }, size = "60% 70%" })
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, size = "60% 70%" })

-- Games get the screen to themselves.
hl.window_rule({ match = { tag = "games" }, no_blur = true, fullscreen = true })

-- JetBrains hover popups steal focus otherwise.
hl.window_rule({ match = { class = "^(jetbrains-.*)$" }, no_initial_focus = true })
hl.window_rule({ match = { title = "^(wind.*)$" },       no_initial_focus = true })

-- Apps open on the current workspace. The old per-tag workspace pinning is in
-- legacy-conf/UserConfigs/WindowRules.conf if it is ever wanted back.

-- ---------------------------------------------------------------------------
-- Layer rules
-- ---------------------------------------------------------------------------

hl.layer_rule({ match = { namespace = "rofi" },                blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "notifications" },       blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "quickshell:overview" }, blur = true, ignore_alpha = 0.5 })
