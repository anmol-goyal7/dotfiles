#!/usr/bin/env bats
# bats no-shorts/tests
# Stages install.sh/uninstall.sh under DESTDIR, so no root and no real browser
# policy is touched. Packing still needs a Chromium-family browser on PATH.

setup() {
  ROOT=$(cd "$BATS_TEST_DIRNAME/.." && pwd)
  export DESTDIR=$BATS_TEST_TMPDIR/root
  CHROME=$DESTDIR/etc/opt/chrome/policies/managed/no-shorts.json
  BRAVE=$DESTDIR/etc/brave/policies/managed/no-shorts.json
  FIREFOX=$DESTDIR/etc/firefox/policies/policies.json
  KEY=$DESTDIR/etc/no-shorts/key.pem
  SHARE=$DESTDIR/usr/local/share/no-shorts
}

key_id() {
  openssl pkey -in "$KEY" -pubout -outform DER | sha256sum | head -c32 | tr 0-9a-f a-p
}

@test "chrome policy blocks the URLs and force-installs the extension" {
  run "$ROOT/install.sh"
  [ "$status" -eq 0 ]
  id=$(key_id)
  run jq -e --arg id "$id" '
    (.URLBlocklist | index("youtube.com/shorts") and index("instagram.com/reels/") and index("instagram.com/reel/"))
    and .ExtensionSettings[$id].installation_mode == "force_installed"
    and .ExtensionSettings[$id].update_url == "file:///usr/local/share/no-shorts/update.xml"
  ' "$CHROME"
  [ "$status" -eq 0 ]
}

@test "brave gets the same policy as chrome" {
  "$ROOT/install.sh"
  cmp "$CHROME" "$BRAVE"
}

@test "the key is private and names the extension in update.xml" {
  "$ROOT/install.sh"
  [ "$(stat -c %a "$KEY")" = 600 ]
  grep -q "appid='$(key_id)'" "$SHARE/update.xml"
  grep -q "codebase='file:///usr/local/share/no-shorts/no-shorts.crx'" "$SHARE/update.xml"
}

@test "the crx is a CRX3 file" {
  "$ROOT/install.sh"
  [ "$(head -c4 "$SHARE/no-shorts.crx")" = Cr24 ]
  [ "$(od -An -tu4 -j4 -N4 "$SHARE/no-shorts.crx" | tr -d ' ')" = 3 ]
}

@test "reinstalling keeps the extension id and bumps the version" {
  "$ROOT/install.sh"
  id=$(key_id)
  grep -q "version='1.0.1'" "$SHARE/update.xml"
  "$ROOT/install.sh"
  [ "$(key_id)" = "$id" ]
  grep -q "version='1.0.2'" "$SHARE/update.xml"
}

@test "firefox policy blocks the URLs and keeps policies it did not write" {
  mkdir -p "${FIREFOX%/*}"
  echo '{"policies":{"DisableTelemetry":true,"WebsiteFilter":{"Block":["*://*.tiktok.com/*"]}}}' > "$FIREFOX"
  "$ROOT/install.sh"
  run jq -e '
    .policies.DisableTelemetry
    and (.policies.WebsiteFilter.Block | index("*://*.tiktok.com/*") and index("*://*.youtube.com/shorts*") and index("*://*.instagram.com/reel/*"))
  ' "$FIREFOX"
  [ "$status" -eq 0 ]
}

@test "uninstall removes everything install wrote" {
  "$ROOT/install.sh"
  run "$ROOT/uninstall.sh"
  [ "$status" -eq 0 ]
  [ ! -e "$CHROME" ] && [ ! -e "$BRAVE" ] && [ ! -e "$FIREFOX" ]
  [ ! -e "$SHARE" ] && [ ! -e "$DESTDIR/etc/no-shorts" ]
}

@test "uninstall leaves other firefox policies alone" {
  mkdir -p "${FIREFOX%/*}"
  echo '{"policies":{"DisableTelemetry":true}}' > "$FIREFOX"
  "$ROOT/install.sh"
  "$ROOT/uninstall.sh"
  run jq -c . "$FIREFOX"
  [ "$output" = '{"policies":{"DisableTelemetry":true}}' ]
}

@test "uninstall copes with a firefox policy that has no WebsiteFilter" {
  mkdir -p "${FIREFOX%/*}"
  echo '{"policies":{"DisableTelemetry":true}}' > "$FIREFOX"
  run "$ROOT/uninstall.sh"
  [ "$status" -eq 0 ]
  run jq -c . "$FIREFOX"
  [ "$output" = '{"policies":{"DisableTelemetry":true}}' ]
}

@test "install refuses to run without root when DESTDIR is unset" {
  [ "$EUID" -ne 0 ] || skip "running as root"
  DESTDIR='' run "$ROOT/install.sh"
  [ "$status" -eq 1 ]
  [[ $output == *sudo* ]]
}
