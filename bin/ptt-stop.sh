#!/usr/bin/env bash
# ptt-stop.sh — push-to-talk, key up. Stops the take, transcribes it locally
# with whisper.cpp, types the text into the focused window and presses Enter.
#
#   - takes under PTT_MIN_SECONDS (0.4 s) are dropped: an accidental tap
#   - [BLANK_AUDIO], (music) and other bracketed tokens are stripped
#   - nothing heard -> nothing typed, and no Enter either
#
# Timings for every take are appended to $XDG_RUNTIME_DIR/ptt.log:
#   stop = release -> recorder closed, asr = whisper, type = wtype,
#   total = release -> text and Enter delivered.

set -u

RUN=${XDG_RUNTIME_DIR:-/tmp}
PIDFILE=$RUN/ptt.pid
LOCK=$RUN/ptt.lock
LOG=$RUN/ptt.log
WAV=/tmp/ptt.wav
PTT_MODEL=$HOME/.local/share/whisper/ggml-small.en.bin
PTT_MIN_SECONDS=0.4
PTT_THREADS=4
PTT_WHISPER_ARGS=(-bs 1 -bo 1)     # greedy decoding; drop for beam search (+~0.2 s)
PTT_ENTER=1
# shellcheck source=/dev/null
[[ -r ~/.config/ptt.conf ]] && source ~/.config/ptt.conf

now() { date +%s.%N; }
t_release=$(now)

notify() { notify-send -a ptt -t 2500 "Dictation" "$1"; }

# ---- stop the recorder --------------------------------------------------------
[[ -s $PIDFILE ]] || exit 0                 # no take running (the common case)
exec 9>"$LOCK"
flock -w 2 9 || exit 1
[[ -s $PIDFILE ]] || exit 0                 # another stop got there first
pid=$(<"$PIDFILE")
rm -f "$PIDFILE"
# TERM, not INT: bash starts `&` jobs of a non-interactive shell with SIGINT
# ignored, so the recorder never sees an INT. timeout forwards TERM, and
# pw-record closes the WAV on it; wait for that so the header is final.
kill -TERM "$pid" 2>/dev/null
for _ in $(seq 100); do kill -0 "$pid" 2>/dev/null || break; sleep 0.01; done
kill -0 "$pid" 2>/dev/null && kill -KILL "$pid" 2>/dev/null

take=$RUN/ptt.$$.wav                        # free /tmp/ptt.wav for the next press
mv -f "$WAV" "$take" 2>/dev/null || exit 0
exec 9>&-
trap 'rm -f "$take"' EXIT
t_stopped=$(now)

# 16 kHz mono s16 = 32000 bytes/s after a 44 byte header.
size=$(stat -c %s "$take")
dur=$(awk -v s="$size" 'BEGIN { printf "%.2f", (s - 44) / 32000 }')
if awk -v d="$dur" -v m="$PTT_MIN_SECONDS" 'BEGIN { exit !(d < m) }'; then
    exit 0
fi

# ---- transcribe ---------------------------------------------------------------
# The encoder normally pads every clip to a 30 s window (audio ctx 1500, 50 per
# second). Sizing it to the clip plus a margin is what makes short takes fast;
# past ~28 s just use the full window.
actx=$(awk -v d="$dur" 'BEGIN { a = int(d * 50) + 128; if (a >= 1400) a = 0; print a }')

raw=$(whisper-cli -m "$PTT_MODEL" -f "$take" -t "$PTT_THREADS" -ac "$actx" \
        -nt -np -sns "${PTT_WHISPER_ARGS[@]}" 2>/dev/null)
t_asr=$(now)

text=$(printf '%s' "$raw" \
    | tr '\n' ' ' \
    | sed -E 's/\[[^]]*\]//g; s/\([^)]*\)//g; s/[[:space:]]+/ /g; s/^ //; s/ $//')

log() {
    awk -v a="$t_release" -v b="$t_stopped" -v c="$t_asr" -v d="$1" -v dur="$dur" \
        -v n="${#text}" -v st="$2" 'BEGIN {
        printf "%s take=%.2fs stop=%.3f asr=%.3f type=%.3f total=%.3f chars=%d %s\n",
            strftime("%F %T"), dur, b-a, c-b, d-c, d-a, n, st }' >>"$LOG"
}

if [[ -z $text ]]; then
    log "$t_asr" empty
    notify "Nothing heard"
    exit 0
fi

# ---- type it ------------------------------------------------------------------
# Hyprland ORs modifiers across every keyboard, wtype's virtual one included.
# Typed while Super is still physically down, "q" would be Super+Q. So wait,
# briefly, for all modifiers to come up; if they don't, hand over the
# clipboard instead of typing into a key combo.
mods_up() {
    python3 -I - <<'PY'
import fcntl, glob, os, sys, time
MODS = (29, 97, 42, 54, 56, 100, 125, 126)   # ctrl shift alt meta, L and R
EVIOCGKEY = (2 << 30) | (96 << 16) | (0x45 << 8) | 0x18
fds = []
for p in glob.glob("/dev/input/event*"):
    try: fds.append(os.open(p, os.O_RDONLY | os.O_NONBLOCK))
    except OSError: pass
deadline = time.monotonic() + 3
while True:
    held = False
    for fd in fds:
        buf = bytearray(96)
        try: fcntl.ioctl(fd, EVIOCGKEY, buf)
        except OSError: continue
        if any(buf[k // 8] >> (k % 8) & 1 for k in MODS):
            held = True
            break
    if not held: sys.exit(0)
    if time.monotonic() > deadline: sys.exit(1)
    time.sleep(0.015)
PY
}

if ! mods_up; then
    printf '%s' "$text" | wl-copy
    log "$(now)" mods-held
    notify "Modifier still held — copied instead: $text"
    exit 0
fi

printf '%s' "$text" | wtype -
(( PTT_ENTER )) && wtype -k Return
log "$(now)" ok
