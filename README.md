# dotfiles

> **Trackpadless Arch Linux** — every action, from window management to mouse clicks, handled by the keyboard.

My personal configuration for **Arch Linux + Hyprland**, built around two ideas:

1. **No trackpad.** Vim motions everywhere: window focus, resize, move, a resize submap with a visual border indicator, and `ydotool` for the rare click nothing else can replace.
2. **OLED battery discipline.** Pure-black Tokyo Night theme across the bar, terminal, and notifications. No wallpaper daemon — the compositor paints solid black (`misc:background_color`). Fewer pixels lit, fewer daemons running.

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
- **OCR anywhere** — `SUPER+SHIFT+T` selects a region, runs tesseract, puts the text on the clipboard.
- **Dropdown terminal** — `SUPER+SHIFT+Return`.
- **Screenshots** — hyprshot region/window/output, saved to `~/Pictures/Screenshots` and copied to the clipboard.
- **System toggles without a mouse** — Wi-Fi `SUPER+F5`, Bluetooth `SUPER+F6`, mute `SUPER+F7`, airplane mode `SUPER+F8`.
- **Notifications** — `SUPER+`` ` `` toggles the SwayNC panel, `SUPER+SHIFT+`` ` `` clears.

## Layout

```
.
├── bin/            power-mode scripts (saver / balance / performance / powermode)
├── etc/sudoers.d/  scoped NOPASSWD rules the power scripts need
├── hypr/           hyprland.conf + UserConfigs/ (keybinds, env, rules, startup)
│   ├── scripts/    helper scripts (refresh, screenshots, toggles, gamemode…)
│   └── shaders/    red-tint night shader (`red` / `blue` zsh aliases)
├── kitty/          kitty.conf + themes (Tokyo Night OLED, gruvbox)
├── nvim/           init.lua, plugins, keymaps (lazy.nvim)
├── swaync/         notification center — Tokyo Night OLED
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
