# 🚀 The Trackpadless Arch Linux Journey

> **"Moving from spatial navigation to command navigation."**

This repository hosts my personal configuration files (dotfiles) for **Arch Linux**, running the **Hyprland** compositor.

The core philosophy of this setup is to completely eliminate the need for a physical trackpad or mouse. I am transitioning to a workflow where every action—from window management to cursor precision—is handled exclusively via the keyboard.

## 💻 System Configuration
* **OS:** Arch Linux
* **Window Manager:** Hyprland (Customized JaKooLit Rice)
* **Terminal:** Kitty
* **Shell:** Zsh
* **Editor:** Neovim
* **Browser Navigation:** Vimium C
* **Hardware:** Laptop (Trackpad Disabled)

## 🎯 The "Sniper Mode" (Mouse Replacement)
To achieve true trackpadless usage without losing functionality, I implemented a custom **Hyprland Submap** called *Sniper Mode*. This uses `ydotool` to emulate mouse input only when absolutely necessary.

**Activation:** Press `Super + G` to enter Mouse Mode.
**Exit:** Press `Escape` to return to normal mode.

| Action | Key | Description |
| :--- | :--- | :--- |
| **Move Left** | `h` | Fast cursor travel (100px) |
| **Move Down** | `j` | Fast cursor travel (100px) |
| **Move Up** | `k` | Fast cursor travel (100px) |
| **Move Right** | `l` | Fast cursor travel (100px) |
| **Precision** | `Shift + h/j/k/l` | Slow, pixel-perfect movement (10px) |
| **Left Click** | `Space` | Standard left click |
| **Right Click** | `s` | Context menu (Right click) |
| **Scroll** | `u` / `d` | Scroll Up / Down |

## 🛠️ Installation & Requirements
These dotfiles rely on the following tools to function correctly:

1. **Dependencies:**
   Ensure `ydotool` is installed for mouse emulation and your user is in the input group:
   ```bash
   yay -S ydotool
   sudo usermod -aG input $USER
   ```

2. **Script Setup:**
   The mouse logic is located in `hypr/scripts/move_mouse.sh`. Ensure it is executable:
   ```bash
   chmod +x ~/.config/hypr/scripts/move_mouse.sh
   ```

---
*Maintained by Anmol Goyal (anmol-goyal7)*
