# 🚫 The Trackpadless Arch Setup

**Author:** Anmol Goyal  
**Goal:** Complete elimination of the trackpad/mouse from the workflow.  
**OS:** Arch Linux (Hyprland)

## 🎯 Philosophy
The goal is to move from "Spatial Navigation" (moving a cursor) to "Command Navigation" (filtering for destinations). This setup uses a combination of Vim motions, tiling window management, and a custom "Sniper Mode" for mouse emulation.

## 🛠️ Key Components
* **WM:** Hyprland (JaKooLit Rice)
* **Shell:** Zsh + Kitty
* **Browser:** Firefox + Vimium C
* **Mouse Emulation:** `ydotool` + Custom Hyprland Submap

## ⌨️ "Sniper Mode" (Mouse Replacement)
**Activation:** `Super + G`  
**Exit:** `Escape`

| Action | Keybind | Description |
| :--- | :--- | :--- |
| **Move Left** | `h` | Fast movement (100px) |
| **Move Down** | `j` | Fast movement (100px) |
| **Move Up** | `k` | Fast movement (100px) |
| **Move Right** | `l` | Fast movement (100px) |
| **Precision** | `Shift + h/j/k/l` | Slow movement (10px) |
| **Left Click** | `Space` | Primary Click |
| **Right Click** | `s` | Context Menu |
| **Scroll** | `u` / `d` | Scroll Up / Down |

## 📂 Installation
1. Install `ydotool` and ensure the user is in the `input` group.
2. Copy the `scripts` folder to `~/.config/hypr/`.
3. Add the keybinds from `UserConfigs/UserKeybinds.conf`.
