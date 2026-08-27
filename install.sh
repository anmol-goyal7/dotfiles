#!/bin/bash
# =============================================================================
# DOTFILES INSTALL SCRIPT
# Symlinks configs from this repo into ~/.config (plus ~/.zshrc, ~/.tmux.conf).
# Safe: backs up anything that already exists before overwriting.
# =============================================================================
set -e

# Repo location = wherever this script lives (works from any clone path)
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[OK]${NC}     $1"; }
warn() { echo -e "${YELLOW}[BACKUP]${NC} $1"; }
info() { echo -e "${GREEN}[INFO]${NC}   $1"; }

# Safe symlink: backs up the destination if it already exists
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    ok "Already linked: $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local bak="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
    warn "Backing up $dst -> $bak"
    mv "$dst" "$bak"
  fi

  ln -sf "$src" "$dst"
  ok "Linked: $src -> $dst"
}

info "Installing dotfiles from $DOTFILES ..."
echo ""

link "$DOTFILES/hypr"           "$CONFIG/hypr"
link "$DOTFILES/kitty"          "$CONFIG/kitty"
link "$DOTFILES/waybar"         "$CONFIG/waybar"
link "$DOTFILES/swaync"         "$CONFIG/swaync"
link "$DOTFILES/yazi"           "$CONFIG/yazi"
link "$DOTFILES/qutebrowser"    "$CONFIG/qutebrowser"
link "$DOTFILES/zathura"        "$CONFIG/zathura"
link "$DOTFILES/nvim"           "$CONFIG/nvim"
link "$DOTFILES/clangd"         "$CONFIG/clangd"
# cmus: only the rc is linked, so cmus's runtime state (cache, lib.pl, saved
# playlists) stays out of the repo instead of landing in it as untracked noise.
link "$DOTFILES/cmus/rc"        "$CONFIG/cmus/rc"

# cmus ships no .desktop file and takes no file arguments, so being the default
# audio handler needs this entry plus bin/cmus-open.
link "$DOTFILES/applications/cmus.desktop" "$HOME/.local/share/applications/cmus.desktop"

link "$DOTFILES/zsh/zshrc"      "$HOME/.zshrc"
link "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# waybar/style.css @imports shift.css, which bin/waybar-pixelshift generates.
# GTK drops the whole stylesheet if that import is missing, so seed it now
# rather than letting a fresh clone come up with an unstyled grey bar.
"$DOTFILES/bin/waybar-pixelshift" --once && ok "Seeded waybar/shift.css (OLED pixel-shift)"

# Make cmus the default player for every audio type. Kept here rather than in a
# tracked mimeapps.list, because that file also holds unrelated browser/PDF
# defaults that shouldn't be stomped on a fresh install.
if command -v xdg-mime >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
  for _m in audio/mpeg audio/mp3 audio/x-mp3 audio/flac audio/x-flac audio/ogg \
    audio/x-ogg audio/vorbis audio/x-vorbis+ogg audio/opus audio/x-opus+ogg \
    audio/wav audio/x-wav audio/x-wavpack audio/mp4 audio/m4a audio/x-m4a \
    audio/aac audio/aacp audio/x-aac audio/webm audio/x-ms-wma \
    audio/x-musepack audio/x-ape audio/aiff audio/x-aiff audio/mpegurl \
    audio/x-mpegurl audio/x-scpls; do
    xdg-mime default cmus.desktop "$_m" 2>/dev/null || true
  done
  ok "cmus set as default audio player"
fi

echo ""
info "All done! Next steps:"
echo ""
echo "  1. Install packages (official repos):"
echo "     sudo pacman -S --needed hyprland kitty waybar swaync rofi-wayland wofi \\"
echo "          zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions \\"
echo "          zoxide fzf fd ripgrep tmux neovim lazygit yazi ueberzugpp \\"
echo "          ffmpegthumbnailer poppler qutebrowser zathura zathura-pdf-mupdf \\"
echo "          btop cliphist wl-clipboard grim slurp tesseract ydotool tlp \\"
echo "          cmus opusfile yt-dlp ffmpeg python-mutagen atomicparsley \\"
echo "          brightnessctl pavucontrol blueman network-manager-applet \\"
echo "          hyprpolkitagent ttf-fantasque-nerd ttf-hack ttf-jetbrains-mono"
echo ""
echo "  2. AUR helpers:   yay -S hyprshot bemoji networkmanager-dmenu"
echo ""
echo "  3. ydotool (keyboard mouse-clicks) needs the input group:"
echo "     sudo usermod -aG input \$USER"
echo ""
echo "  4. Power modes (saver/balance/performance in bin/) need the sudoers"
echo "     rules — review them first, then:"
echo "     sudo cp $DOTFILES/etc/sudoers.d/power-modes /etc/sudoers.d/power-modes"
echo "     sudo chmod 440 /etc/sudoers.d/power-modes"
echo ""
echo "  5. Reload shell:    source ~/.zshrc"
echo "  6. Reload Hyprland: SUPER+ALT+R  (or log out/in)"
echo ""
echo "  Neovim: plugins auto-install on first launch, then run"
echo "     :MasonInstall lua-language-server pyright bash-language-server"
