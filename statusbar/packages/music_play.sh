#! /bin/bash

source ~/.profile
this=_music_play
icon_color="^c#3B001B^^b#ffb6c10x88^"
text_color="^c#3B001B^^b#ffb6c10x99^"
signal=$(echo "^s$this^" | sed 's/_//')

update() {
    play_status=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.yesplaymusic /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:PlaybackStatus | grep -Eo '".*?"' | cut -d '"' -f 2) 2>/dev/null
    
    if [ "$play_status" == "Paused" ];  then icon="  ";
    elif [ "$play_status" == "Playing"  ]; then icon=" 󰏤 ";
    else icon="  ";
    fi
    text=""
    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

Play_Pause() {
  playerctl play-pause 
  # update
}

click() {
    case "$1" in
      L) Play_Pause;;
      M) ;;
      R) ;;
      U) ;;
      D) ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
