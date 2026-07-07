# =============================================================================
# QUTEBROWSER CONFIG — VIM-FIRST BROWSER
# Symlink: ln -sf ~/repos/dotfiles/qutebrowser ~/.config/qutebrowser
# =============================================================================
config.load_autoconfig(False)

# =============================================================================
# APPEARANCE
# =============================================================================
c.fonts.default_family = "FantasqueSansM Nerd Font Mono"
c.fonts.default_size = "12pt"
c.fonts.web.size.default = 16
c.fonts.web.size.default_fixed = 13

# Dark mode
config.set("colors.webpage.preferred_color_scheme", "dark")
config.set("colors.webpage.darkmode.enabled", True)
config.set("colors.webpage.darkmode.policy.images", "never")

# Catppuccin Mocha colors
bg_base   = "#1e1e2e"
bg_mantle = "#181825"
bg_crust  = "#11111b"
bg1       = "#313244"
bg2       = "#45475a"
fg        = "#cdd6f4"
fg_dim    = "#a6adc8"
blue      = "#89b4fa"
mauve     = "#cba6f7"
red       = "#f38ba8"
green     = "#a6e3a1"
yellow    = "#f9e2af"
peach     = "#fab387"

# Tab bar
c.colors.tabs.bar.bg             = bg_base
c.colors.tabs.odd.bg             = bg_base
c.colors.tabs.odd.fg             = fg_dim
c.colors.tabs.even.bg            = bg_base
c.colors.tabs.even.fg            = fg_dim
c.colors.tabs.selected.odd.bg    = bg1
c.colors.tabs.selected.odd.fg    = blue
c.colors.tabs.selected.even.bg   = bg1
c.colors.tabs.selected.even.fg   = blue
c.colors.tabs.pinned.odd.bg      = bg_mantle
c.colors.tabs.pinned.odd.fg      = green
c.colors.tabs.pinned.even.bg     = bg_mantle
c.colors.tabs.pinned.even.fg     = green

# URL bar
c.colors.statusbar.normal.bg     = bg_mantle
c.colors.statusbar.normal.fg     = fg
c.colors.statusbar.url.fg        = fg
c.colors.statusbar.url.success.https.fg = green
c.colors.statusbar.url.error.fg  = red
c.colors.statusbar.url.warn.fg   = yellow
c.colors.statusbar.insert.bg     = bg1
c.colors.statusbar.insert.fg     = blue
c.colors.statusbar.command.bg    = bg_mantle
c.colors.statusbar.command.fg    = fg

# Completion menu
c.colors.completion.fg              = fg
c.colors.completion.odd.bg          = bg_base
c.colors.completion.even.bg         = bg_mantle
c.colors.completion.category.bg     = bg_crust
c.colors.completion.category.fg     = blue
c.colors.completion.item.selected.bg  = bg1
c.colors.completion.item.selected.fg  = fg
c.colors.completion.item.selected.border.top    = bg1
c.colors.completion.item.selected.border.bottom = bg1
c.colors.completion.match.fg        = mauve
c.colors.completion.scrollbar.bg    = bg1
c.colors.completion.scrollbar.fg    = fg_dim

# Hints
c.colors.hints.bg     = yellow
c.colors.hints.fg     = bg_base
c.colors.hints.match.fg = peach
c.hints.border        = "1px solid " + bg_base

# Messages
c.colors.messages.error.bg   = red
c.colors.messages.error.fg   = bg_base
c.colors.messages.warning.bg = yellow
c.colors.messages.warning.fg = bg_base
c.colors.messages.info.bg    = bg1
c.colors.messages.info.fg    = fg

# =============================================================================
# BEHAVIOR
# =============================================================================
c.auto_save.session = True
c.content.autoplay = False
c.content.notifications.enabled = False
c.downloads.location.directory = "~/Downloads"
c.downloads.location.prompt = False
c.downloads.open_dispatcher = "xdg-open"
c.editor.command = ["kitty", "-e", "nvim", "{}"]
c.scrolling.smooth = True
c.session.lazy_restore = True
c.spellcheck.languages = ["en-US"]
c.tabs.last_close = "close"
c.tabs.mousewheel_switching = False  # Keyboard only
c.tabs.position = "top"
c.tabs.show = "multiple"
c.tabs.title.format = "{audio}{current_title}"
c.url.default_page = "about:blank"
c.url.start_pages = ["about:blank"]
c.window.title_format = "{perc}{current_title}"
c.zoom.default = "100%"

# Hint characters (home row first)
c.hints.chars = "asdfghjklqwertyuiop"

# Privacy
c.content.cookies.accept = "no-3rdparty"

# =============================================================================
# SEARCH ENGINES
# =============================================================================
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g":  "https://www.google.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "w":  "https://en.wikipedia.org/wiki/{}",
    "r":  "https://www.reddit.com/search/?q={}",
    "py": "https://docs.python.org/3/search.html?q={}",
    "mdn":"https://developer.mozilla.org/en-US/search?q={}",
    "nv": "https://neovim.io/doc/user/",
    "ap": "https://archlinux.org/packages/?q={}",
    "au": "https://aur.archlinux.org/packages?K={}",
}

# =============================================================================
# KEYBINDINGS
# =============================================================================

# --- Tab management ---
config.bind("J",       "tab-prev")
config.bind("K",       "tab-next")
config.bind("x",       "tab-close")
config.bind("X",       "undo")
config.bind("gp",      "tab-pin")
config.bind("<Ctrl-t>","open -t")

# --- Quick tab navigation ---
config.bind("<Alt-1>", "tab-focus 1")
config.bind("<Alt-2>", "tab-focus 2")
config.bind("<Alt-3>", "tab-focus 3")
config.bind("<Alt-4>", "tab-focus 4")
config.bind("<Alt-5>", "tab-focus 5")

# --- Navigation ---
config.bind("<Ctrl-d>", "scroll-page 0 0.5")
config.bind("<Ctrl-u>", "scroll-page 0 -0.5")
config.bind("<Ctrl-f>", "scroll-page 0 1")
config.bind("<Ctrl-b>", "scroll-page 0 -1")

# --- Editing in insert mode ---
config.bind("<Escape>", "mode-enter normal", mode="insert")
config.bind("jk",       "mode-enter normal", mode="insert")

# --- Misc ---
config.bind(",r",  "reload")
config.bind(",R",  "reload -f")
config.bind(",m",  "bookmark-add")
config.bind(",e",  "edit-url")
config.bind(",y",  "yank url")
config.bind(",Y",  "yank title")
config.bind(",s",  "view-source")
config.bind(",p",  "open -- {clipboard}")
config.bind("yy",  "yank url")
config.bind("yt",  "yank title")
