# dotfiles

> **Trackpadless Arch Linux** — every action, from window management to mouse clicks, handled by the keyboard.

My personal configuration for **Arch Linux + Hyprland**, built around two ideas:

1. **No trackpad.** Vim motions everywhere: window focus, resize, move, a resize submap with a visual border indicator, and `ydotool` for the rare click nothing else can replace.
2. **OLED discipline.** Pure-black Tokyo Night theme across the bar, terminal, and notifications. No wallpaper daemon — the compositor paints solid black (`misc:background_color`). Colour lives in text rather than in filled backgrounds, so nothing bright sits parked at fixed pixels. The screen always blanks after 5 min idle — `afk` cannot override that, only the lock and suspend steps. `bin/waybar-pixelshift` walks the bar's contents around a 4x3 pixel grid so the clock and tray icons never sit on the same subpixels for a whole uptime. Fewer pixels lit, fewer daemons running, and a panel that ages slowly.

## Components

| Piece | Tool | Config |
| :--- | :--- | :--- |
| Compositor | [Hyprland](https://hyprland.org) ≥ 0.56, Lua config | `hypr/` |
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
- **Zen mode** — `SUPER+F5` locks you into the window you are working in. Entering a `zen` submap makes every global bind inactive at once — no launcher, no workspace switch, no window movement, no `SUPER`+drag; only `SUPER+F5` to leave, the XF86 hardware keys and the lock screen are re-declared inside it. Keybinds are only half of it, so a watcher on Hyprland's event socket snaps focus back when a click or a newly opened window takes it, which also drags you back from another workspace. New-tab and new-window keys are swallowed: `CTRL+SHIFT+T`/`N` and `ALT+TAB` always, and the plain `CTRL+T/N/L/TAB/1-9` group only when the locked window is a browser — in a terminal those are work keys. Notifications go quiet apart from the low-battery warning, which passes do-not-disturb on critical urgency. Border turns purple. It releases itself if the locked window closes, and the submap is declared in the config (`hypr/lua/submaps.lua`) rather than built at runtime, so a config reload rebuilds it instead of emptying it — neither can lock you out. Leaving zen re-reads the config to restore the binds, which would otherwise hand the red tint and the current power mode's blur and animation settings back to the config — both live only at runtime — so it snapshots them across the reload.
- **Low battery warning that goes away** — `bin/battery-low-warning --watch` runs as a systemd user service, blocking on `upower` events rather than polling. The warning is sticky by design (critical urgency, `timeout-critical: 0`), so it records its notification id and closes it over D-Bus the moment the charger goes in.
- **OCR anywhere** — `SUPER+SHIFT+T` selects a region, runs tesseract, puts the text on the clipboard.
- **Dropdown terminal** — `SUPER+SHIFT+Return`.
- **Screenshots** — hyprshot region/window/output, saved to `~/Pictures/Screenshots` and copied to the clipboard.
- **Red mode** — `SUPER+N`, or `red` / `blue` at a prompt. A fragment shader that drops the green and blue channels outright, so the screen goes fully red for night work. It hangs on `decoration:screen_shader`, which exists only at runtime, so every `hyprctl reload` used to silently drop it — leaving zen mode, leaving game mode, or Hyprland re-reading its own config after an edit. `bin/red` keeps a state file and a `reapply` verb, which those paths call once they are done reloading.
- **System toggles without a mouse** — Wi-Fi `SUPER+F9`, Bluetooth `SUPER+F6`, mute `SUPER+F7`, airplane mode `SUPER+F8`.
- **Notifications** — `SUPER+`` ` `` toggles the SwayNC panel, `SUPER+SHIFT+`` ` `` clears.
- **OLED pixel-shift** — the bar's contents drift 0–3px every 10 minutes, via a flash-free waybar style reload you will not notice.
- **An idle ladder that always comes back** — dim at 2.5 min, lock at 4.5, screen off at 5, suspend at 10. The lock deliberately lands *before* the blank: hyprlock takes the `ext-session-lock` the moment it starts, and the protocol says a compositor whose lock client dies must keep painting black and keep swallowing input, so starting it onto an already-dark output was a way to end up at a screen only the power button could clear. The bigger trap was `hl.dsp.dpms("on")`: on 0.56.2 the Lua bridge **ignores the argument and toggles**, so the resume path fired it twice — once from the listener, once from `after_sleep_cmd` — and turned the screen back off every time the laptop woke. `bin/dpms on|off` reads the real state and only toggles when it differs; `bin/lock` supervises hyprlock and re-attaches a lock surface if it dies rather than leaving a dead one; `bin/screen-wake` undoes all three ways the screen can be left dark. If it ever wedges anyway: `Ctrl+Alt+F2`, log in, `screen-wake`, `Ctrl+Alt+F1`.

## Hyprland config is Lua

Hyprland 0.56 deprecated the `.conf` format and 0.57 drops it, so `hypr/` is a
Lua config: `hyprland.lua` requires the modules under `hypr/lua/`. Hyprland
prefers `hyprland.lua` and only falls back to `hyprland.conf`, which is a shim
onto `hypr/legacy-conf/` — the old tree, unchanged apart from its paths. Rename
`hyprland.lua` and the next login comes up exactly as it did before.

Two things changed for anything scripting the compositor:

| Was | Is |
| :--- | :--- |
| `hyprctl keyword a:b <v>` | `hyprctl eval 'hl.config({a={b=<v>}})'`, wrapped by `bin/hlset` |
| `hyprctl dispatch X Y` | `hyprctl dispatch 'hl.dsp.x.y(...)'` |

`hyprctl getoption`, `clients`, `monitors`, `devices` and `reload` are
unchanged. `hyprctl binds` now reports every dispatcher as an opaque `__lua`
handle, so `bin/keys` (the `SUPER+/` cheatsheet) reads a registry that
`hypr/lua/util.lua` keeps inside the compositor instead — which means it covers
the default and laptop binds too, not just the personal ones.

`Hyprland --verify-config -c hypr/hyprland.lua` type-checks the whole thing
without touching the running session.

## Layout

```
.
├── bin/            power modes, `afk` keep-awake, focus modes, `red` tint, battery warning, waybar pixel-shift,
│                `dpms`/`screen-wake`/`lock` — the idle ladder's safety net
├── etc/sudoers.d/  scoped NOPASSWD rules the power scripts need
├── hypr/           hyprland.lua — the Hyprland config, in Lua
│   ├── lua/        the config proper: binds, rules, look, settings, submaps
│   ├── legacy-conf/ the pre-0.56 .conf tree, kept as a fallback
│   ├── scripts/    helper scripts (refresh, screenshots, toggles, gamemode…)
│   └── shaders/    red-tint night shader, driven by `bin/red`
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
