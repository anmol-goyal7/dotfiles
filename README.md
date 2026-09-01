# dotfiles

> **Trackpadless Arch Linux** — every action, from window management to mouse clicks, handled by the keyboard.

My personal configuration for **Arch Linux + Hyprland**, built around two ideas:

1. **No trackpad.** Vim motions everywhere: window focus, resize, move, a resize submap with a visual border indicator, and `ydotool` for the rare click nothing else can replace.
2. **OLED discipline.** Pure-black Tokyo Night theme across the bar, terminal, and notifications. No wallpaper daemon — the compositor paints solid black (`misc:background_color`). Colour lives in text rather than in filled backgrounds, so nothing bright sits parked at fixed pixels. The screen always blanks after 5 min idle — `afk` cannot override that, only the lock and suspend steps. `bin/waybar-pixelshift` walks the bar's contents around a 4x3 pixel grid so the clock and tray icons never sit on the same subpixels for a whole uptime. Fewer pixels lit, fewer daemons running, and a panel that ages slowly.

## Components

| Piece | Tool | Config |
| :--- | :--- | :--- |
| Compositor | [Hyprland](https://hyprland.org) | `hypr/` |
| Bar | Waybar (Tokyo Night OLED) | `waybar/` |
| Notifications | SwayNC (matching theme) | `swaync/` |
| Terminal | kitty | `kitty/` |
| Shell | zsh — vim mode, fzf, zoxide, autosuggestions | `zsh/` |
| Editor | Neovim (lazy.nvim + Mason) | `nvim/` |
| Multiplexer | tmux | `tmux/` |
| Launcher | wofi (spotlight) / rofi (dashboard) | — |
| Files | yazi (TUI, auto-cd on exit) | `yazi/` |
| Browser | qutebrowser (vim-keys) | `qutebrowser/` |
| PDFs | zathura | `zathura/` |
| Power profiles | custom `bin/` scripts + TLP | `bin/`, `etc/` |

## Highlights

- **Vim-motion window control** — `SUPER+hjkl` focus, `SUPER+SHIFT+hjkl` resize, `SUPER+CTRL+hjkl` move, `SUPER+R` enters a resize submap (border turns red until `Esc`).
- **Keyboard mouse clicks** — `SUPER+CTRL+Space` / `SUPER+CTRL+x` left/right click via ydotool.
- **Power modes on function keys** — `SUPER+F1..F4` switch battery-saver / balanced / performance profiles (cpupower + Intel P-State + TLP, wired through scoped sudoers rules in `etc/sudoers.d/`).
- **Zen mode** — `SUPER+F5` toggles a lock-in mode: every bind that moves, resizes, floats or reorders a window is unbound (`SUPER`+drag included), so the window you are working in stays put. Focus, workspace switching and launchers still work, and fullscreen is left alone on purpose. Notifications go quiet except the low-battery warning, which is sent at critical urgency — swaync lets those through do-not-disturb. The border turns purple while it is on. `bin/zen` reads the bind list from `hyprctl binds -j` instead of hardcoding it, and leaves the mode with `hyprctl reload config-only`, so it can never strand you without keys.
- **Low battery warning that goes away** — `bin/battery-low-warning --watch` runs as a systemd user service, blocking on `upower` events rather than polling. The warning is sticky by design (critical urgency, `timeout-critical: 0`), so it records its notification id and closes it over D-Bus the moment the charger goes in.
- **OCR anywhere** — `SUPER+SHIFT+T` selects a region, runs tesseract, puts the text on the clipboard.
- **Dropdown terminal** — `SUPER+SHIFT+Return`.
- **Screenshots** — hyprshot region/window/output, saved to `~/Pictures/Screenshots` and copied to the clipboard.
- **System toggles without a mouse** — Wi-Fi `SUPER+F9`, Bluetooth `SUPER+F6`, mute `SUPER+F7`, airplane mode `SUPER+F8`.
- **Notifications** — `SUPER+`` ` `` toggles the SwayNC panel, `SUPER+SHIFT+`` ` `` clears.
- **OLED pixel-shift** — the bar's contents drift 0–3px every 10 minutes, via a flash-free waybar style reload you will not notice.

## Layout

```
.
├── bin/            power modes, `afk` keep-awake, focus modes, battery warning, waybar pixel-shift
├── etc/sudoers.d/  scoped NOPASSWD rules the power scripts need
├── hypr/           hyprland.conf + UserConfigs/ (keybinds, env, rules, startup)
│   ├── scripts/    helper scripts (refresh, screenshots, toggles, gamemode…)
│   └── shaders/    red-tint night shader (`red` / `blue` zsh aliases)
├── kitty/          kitty.conf + themes (Tokyo Night OLED, gruvbox)
├── nvim/           init.lua, plugins, keymaps (lazy.nvim)
├── swaync/         notification center — Tokyo Night OLED
├── systemd/user/   the low-battery warning service
├── waybar/         bar config + Tokyo Night OLED style
├── zsh/            zshrc — vim mode, fzf, zoxide, plugins
├── tmux/ yazi/ qutebrowser/ zathura/
└── install.sh      symlinks everything into place (with backups)
```

## Install

```bash
git clone https://github.com/anmol-goyal7/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles
./install.sh
```

`install.sh` symlinks configs into `~/.config` (backing up anything it would
replace) and prints the package list for a fresh Arch setup — core packages
from the official repos, plus `hyprshot`, `bemoji`, and `networkmanager-dmenu`
from the AUR.

Extras that need one-time setup:

```bash
# ydotool (keyboard mouse clicks)
sudo usermod -aG input $USER

# power modes — review the rules first, then:
sudo cp etc/sudoers.d/power-modes /etc/sudoers.d/power-modes
sudo chmod 440 /etc/sudoers.d/power-modes
```

**Fonts:** `ttf-fantasque-nerd` (bar + notifications), `ttf-hack` (terminal), `ttf-jetbrains-mono`.

---
*Maintained by [Anmol Goyal](https://github.com/anmol-goyal7).*
