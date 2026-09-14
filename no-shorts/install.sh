#!/usr/bin/env bash
# Blocks YouTube Shorts and Instagram Reels in Chrome, Brave and Firefox for
# good: no schedule, no off switch, and neither browser lets you remove it.
#   sudo ./install.sh        install, or upgrade after editing extension/
#   sudo ./uninstall.sh      the only way back out
# DESTDIR=/tmp/x ./install.sh stages everything under /tmp/x, no root needed.
set -euo pipefail

SHARE=/usr/local/share/no-shorts
KEY=/etc/no-shorts/key.pem
CHROME_POLICY=/etc/opt/chrome/policies/managed/no-shorts.json
BRAVE_POLICY=/etc/brave/policies/managed/no-shorts.json
FIREFOX_POLICY=/etc/firefox/policies/policies.json
D=${DESTDIR:-}

# Chrome's blocklist matches host (subdomains included) plus a path prefix.
URLS='["youtube.com/shorts", "instagram.com/reels/", "instagram.com/reel/"]'
# Firefox's WebsiteFilter takes match patterns, and *.host covers the bare host.
FIREFOX_URLS='[
  "*://*.youtube.com/shorts*", "*://*.youtube.com/*/shorts*",
  "*://*.instagram.com/reels/*", "*://*.instagram.com/reel/*",
  "*://*.instagram.com/*/reels/*", "*://*.instagram.com/*/reel/*"
]'

die() { echo "install.sh: $*" >&2; exit 1; }

[[ -n $D || $EUID -eq 0 ]] || die "run me with sudo"
for tool in openssl jq sha256sum; do
  command -v "$tool" >/dev/null || die "needs $tool"
done
browser=''
for b in google-chrome-stable google-chrome chromium brave; do
  command -v "$b" >/dev/null && { browser=$b; break; }
done
[[ -n $browser ]] || die "needs Chrome, Chromium or Brave to pack the extension"
cd "$(dirname "$(readlink -f "$0")")"

# The key is made once and never replaced: the extension id is derived from it
# and the policy names that id. It stays out of the repo because it is private.
install -d -m700 "$D${KEY%/*}"
[[ -f $D$KEY ]] || openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "$D$KEY" 2>/dev/null
chmod 600 "$D$KEY"
id=$(openssl pkey -in "$D$KEY" -pubout -outform DER | sha256sum | head -c32 | tr 0-9a-f a-p)

# A browser only takes an update whose version is higher than what it has, so
# every install is one build past the last.
build=0
if [[ -f $D$SHARE/update.xml ]]; then
  build=$(grep -o "version='[0-9.]*'" "$D$SHARE/update.xml" | grep -o '[0-9]*' | tail -1)
fi
version=1.0.$((build + 1))

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
mkdir "$stage/ext"
cp extension/no-shorts.user.js "$stage/ext/"
jq --arg v "$version" '.version = $v' extension/manifest.json > "$stage/ext/manifest.json"

sandbox=()
[[ $EUID -eq 0 ]] && sandbox=(--no-sandbox)   # Chrome will not start as root without it
"$browser" --headless=new "${sandbox[@]}" --user-data-dir="$stage/profile" \
  --pack-extension="$stage/ext" --pack-extension-key="$D$KEY" >/dev/null 2>&1 || true
[[ -s $stage/ext.crx ]] || die "$browser failed to pack the extension"

cat > "$stage/update.xml" <<EOF
<?xml version='1.0' encoding='UTF-8'?>
<gupdate xmlns='http://www.google.com/update2/response' protocol='2.0'>
  <app appid='$id'>
    <updatecheck codebase='file://$SHARE/no-shorts.crx' version='$version' />
  </app>
</gupdate>
EOF

jq -n --argjson urls "$URLS" --arg id "$id" --arg update "file://$SHARE/update.xml" '{
  URLBlocklist: $urls,
  ExtensionSettings: {($id): {installation_mode: "force_installed", update_url: $update}}
}' > "$stage/policy.json"

# Merged, not overwritten: policies.json is one file shared by every policy.
if [[ -f $D$FIREFOX_POLICY ]]; then cp "$D$FIREFOX_POLICY" "$stage/firefox.json"; else echo '{}' > "$stage/firefox.json"; fi
jq --argjson urls "$FIREFOX_URLS" \
  '.policies.WebsiteFilter.Block = ((.policies.WebsiteFilter.Block // []) + $urls | unique)' \
  "$stage/firefox.json" > "$stage/firefox.new"

install -Dm644 "$stage/ext.crx"     "$D$SHARE/no-shorts.crx"
install -Dm644 "$stage/update.xml"  "$D$SHARE/update.xml"
install -Dm644 "$stage/policy.json" "$D$CHROME_POLICY"
install -Dm644 "$stage/policy.json" "$D$BRAVE_POLICY"
install -Dm644 "$stage/firefox.new" "$D$FIREFOX_POLICY"

echo "no-shorts $version installed (extension $id)."
echo "Restart Chrome/Brave/Firefox, or open chrome://policy and press \"Reload policies\"."
