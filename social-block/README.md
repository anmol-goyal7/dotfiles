# social-block

Null-routes the usual time sinks in `/etc/hosts` between **22:00 and 06:00**, on
a pair of systemd timers. Covers instagram, linkedin, x/twitter and reddit with
their `www.`/`m.` variants, plus the short links and alternate doors (`t.co`,
`lnkd.in`, `instagr.am`, `redd.it`, `old.`/`new.`/`np.reddit.com` — the last of
which happily serves the whole site past a plain `reddit.com` block).

## Install

    sudo ./install.sh

Script to `/usr/local/bin`, units to `/etc/systemd/system`, both timers enabled,
then `systemctl list-timers` so you can check it.

## Toggle by hand

    sudo social-block on      # block right now
    sudo social-block off     # unblock right now

Safe to repeat — "on" twice will not stack a second copy. Changes only the
current state; the timers still flip it at the next 22:00 or 06:00.

## Turn it off permanently

    sudo systemctl disable --now social-block-on.timer social-block-off.timer
    sudo social-block off
    # and to remove it outright:
    sudo rm /usr/local/bin/social-block /etc/systemd/system/social-block-*
    sudo systemctl daemon-reload

## The DoH caveat — this is the one that bites

If the browser resolves names itself over DNS-over-HTTPS it never asks the system
resolver, never sees `/etc/hosts`, and this blocker **silently does nothing**
while still looking installed and active.

- **Chrome:** Settings → Privacy and security → Security → *Use secure DNS* **off**
- **Firefox:** `about:config` → `network.trr.mode` = **5** (off by choice)

WARP is fine as-is: it only changes which resolver answers, and `/etc/hosts` is
read ahead of any resolver. In-browser DoH is what skips the file.

## Notes

- Only the region between `# BEGIN social-block` and `# END social-block` is
  rewritten; the rest of `/etc/hosts` is untouched, previous copy at `/etc/hosts.bak`.
- `Persistent=true` replays a run missed while the laptop was off, so each service
  re-checks the clock first — a boot at noon cannot replay 22:00 and leave you
  blocked all day. Side effect: `systemctl start social-block-on` no-ops outside
  the window; use `sudo social-block on`.
- Open tabs and the browser's DNS cache outlive the switch (Chrome:
  `chrome://net-internals/#dns`). A speed bump, not a lock — you have sudo.
