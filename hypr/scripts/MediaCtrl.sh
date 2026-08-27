#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Playerctl — with cmus support (cmus has no MPRIS, so it's driven via cmus-remote)

music_icon="$HOME/.config/swaync/icons/music.png"

# cmus takes priority when it's running, otherwise fall back to playerctl
cmus_running() { cmus-remote -Q >/dev/null 2>&1; }

# Play the next track
play_next() {
  if cmus_running; then cmus-remote --next; else playerctl next; fi
  show_music_notification
}

# Play the previous track
play_previous() {
  if cmus_running; then cmus-remote --prev; else playerctl previous; fi
  show_music_notification
}

# Toggle play/pause
toggle_play_pause() {
  if cmus_running; then cmus-remote --pause; else playerctl play-pause; fi
  sleep 0.1
  show_music_notification
}

# Stop playback
stop_playback() {
  if cmus_running; then cmus-remote --stop; else playerctl stop; fi
  notify-send -e -u low -i $music_icon " Playback:" " Stopped"
}

# Display notification with song information
show_music_notification() {
  if cmus_running; then
    local q status song_title song_artist
    q=$(cmus-remote -Q 2>/dev/null)
    status=$(awk '/^status /{print $2}' <<<"$q")
    song_title=$(sed -n 's/^tag title //p' <<<"$q")
    song_artist=$(sed -n 's/^tag artist //p' <<<"$q")
    # untagged files: fall back to the filename
    [[ -z "$song_title" ]] && song_title=$(basename "$(sed -n 's/^file //p' <<<"$q")")
    [[ -z "$song_artist" ]] && song_artist="Unknown artist"
    case "$status" in
    playing) notify-send -e -u low -i $music_icon "Now Playing:" "$song_title by $song_artist" ;;
    paused) notify-send -e -u low -i $music_icon " Playback:" " Paused" ;;
    esac
    return
  fi

  status=$(playerctl status)
  if [[ "$status" == "Playing" ]]; then
    song_title=$(playerctl metadata title)
    song_artist=$(playerctl metadata artist)
    notify-send -e -u low -i $music_icon "Now Playing:" "$song_title by $song_artist"
  elif [[ "$status" == "Paused" ]]; then
    notify-send -e -u low -i $music_icon " Playback:" " Paused"
  fi
}

# Get media control action from command line argument
case "$1" in
"--nxt")
  play_next
  ;;
"--prv")
  play_previous
  ;;
"--pause")
  toggle_play_pause
  ;;
"--stop")
  stop_playback
  ;;
*)
  echo "Usage: $0 [--nxt|--prv|--pause|--stop]"
  exit 1
  ;;
esac
