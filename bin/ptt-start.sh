#!/usr/bin/env bash
# ptt-start.sh — push-to-talk, key down (Super+Y; released -> ptt-stop.sh).
#
# Records the default mic to /tmp/ptt.wav as 16 kHz mono s16, the format
# whisper.cpp wants, so ptt-stop.sh never has to resample. Key repeat, or a
# second press while a take is still running, is a no-op: the PID file is
# checked under a lock, and only a live pw-record behind it counts.
#
# Overrides go in ~/.config/ptt.conf (sourced by both scripts), e.g.
#   PTT_RECORD_ARGS=(--target alsa_input.usb-...)   # pick a mic
#   PTT_MAX_SECONDS=120                             # hard stop for a lost release

set -u

RUN=${XDG_RUNTIME_DIR:-/tmp}
PIDFILE=$RUN/ptt.pid
LOCK=$RUN/ptt.lock
WAV=/tmp/ptt.wav
PTT_RECORD_ARGS=()
PTT_MAX_SECONDS=120
PTT_BEEP_START=/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga
# shellcheck source=/dev/null
[[ -r ~/.config/ptt.conf ]] && source ~/.config/ptt.conf

exec 9>"$LOCK"
flock -n 9 || exit 0          # another start/stop is mid-flight

if [[ -s $PIDFILE ]]; then
    pid=$(<"$PIDFILE")
    # Live recorder? Then this is key repeat — leave it alone.
    if kill -0 "$pid" 2>/dev/null && [[ $(ps -o args= -p "$pid") == *pw-record* ]]; then
        exit 0
    fi
    rm -f "$PIDFILE"              # stale: the last take died without a stop
fi

rm -f "$WAV"
# `timeout` bounds a take whose release never arrives; it forwards SIGTERM to
# pw-record, which then closes the WAV cleanly.
setsid timeout "$PTT_MAX_SECONDS" \
    pw-record --rate 16000 --channels 1 --format s16 "${PTT_RECORD_ARGS[@]}" "$WAV" \
    </dev/null >/dev/null 2>&1 9>&- &      # 9>&-: the recorder must not hold the lock
echo $! >"$PIDFILE"
date +%s.%N >"$RUN/ptt.t0"

[[ -r $PTT_BEEP_START ]] && { pw-play "$PTT_BEEP_START" >/dev/null 2>&1 9>&- & }
exit 0
