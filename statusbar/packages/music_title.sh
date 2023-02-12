#! /bin/bash

source ~/.profile
this=_music_title
icon_color="^c#3B001B^^b#ffb6c10x88^"
text_color="^c#3B001B^^b#ffb6c10x99^"
signal=$(echo "^s$this^" | sed 's/_//')

update() {
    # refer : https://risehere.net/posts/obs-now-playing/
    # title=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.yesplaymusic /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2 | cut -c -30) 2>/dev/null
    title=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.yesplaymusic /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2) 2>/dev/null
    icon="🎵"
    text="$title"

    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

click() {
    case "$1" in
        L) xdotool keydown Super m keyup m Super;;
        M) ;;
        # R) call_htop ;;
        U) ;;
        D) ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
