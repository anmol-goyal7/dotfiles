#!/usr/bin/env bash
# Installs the blocker system-wide:  sudo ./install.sh
set -euo pipefail
[[ $EUID -eq 0 ]] || { echo "install.sh: run me with sudo" >&2; exit 1; }
cd "$(dirname "$(readlink -f "$0")")"

install -Dm755 social-block /usr/local/bin/social-block
install -Dm644 -t /etc/systemd/system social-block-{on,off}.{service,timer}
systemctl daemon-reload
systemctl enable --now social-block-on.timer social-block-off.timer

echo
systemctl list-timers 'social-block-*' --all
