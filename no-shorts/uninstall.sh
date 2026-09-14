#!/usr/bin/env bash
# Removes what install.sh put in place. Chrome and Brave uninstall the
# extension themselves once its policy is gone.
#   sudo ./uninstall.sh
set -euo pipefail

SHARE=/usr/local/share/no-shorts
KEY_DIR=/etc/no-shorts
CHROME_POLICY=/etc/opt/chrome/policies/managed/no-shorts.json
BRAVE_POLICY=/etc/brave/policies/managed/no-shorts.json
FIREFOX_POLICY=/etc/firefox/policies/policies.json
D=${DESTDIR:-}

[[ -n $D || $EUID -eq 0 ]] || { echo "uninstall.sh: run me with sudo" >&2; exit 1; }
command -v jq >/dev/null || { echo "uninstall.sh: needs jq" >&2; exit 1; }

rm -f "$D$CHROME_POLICY" "$D$BRAVE_POLICY"
rm -rf "$D$SHARE" "$D$KEY_DIR"

# Take back only the patterns install.sh added; drop the file if that empties it.
if [[ -f $D$FIREFOX_POLICY ]]; then
  left=$(jq -c '
    if .policies.WebsiteFilter.Block then
      .policies.WebsiteFilter.Block -= [
        "*://*.youtube.com/shorts*", "*://*.youtube.com/*/shorts*",
        "*://*.instagram.com/reels/*", "*://*.instagram.com/reel/*",
        "*://*.instagram.com/*/reels/*", "*://*.instagram.com/*/reel/*"
      ]
      | if .policies.WebsiteFilter.Block == [] then del(.policies.WebsiteFilter.Block) else . end
      | if .policies.WebsiteFilter == {} then del(.policies.WebsiteFilter) else . end
    else . end
    | if .policies == {} then del(.policies) else . end
  ' "$D$FIREFOX_POLICY")
  if [[ $left == '{}' ]]; then
    rm -f "$D$FIREFOX_POLICY"
  else
    printf '%s\n' "$left" | jq . > "$D$FIREFOX_POLICY.new"
    mv "$D$FIREFOX_POLICY.new" "$D$FIREFOX_POLICY"
  fi
fi

echo "no-shorts removed. Restart your browsers to drop the extension."
