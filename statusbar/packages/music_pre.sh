#! /bin/bash

source ~/.profile
this=_music_pre
icon_color="^c#3B001B^^b#ffb6c10x88^"
text_color="^c#3B001B^^b#ffb6c10x99^"
signal=$(echo "^s$this^" | sed 's/_//')

update() {
    icon=" 󰒮"
    text=""
    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

click() {
    case "$1" in
        L) playerctl previous ;;
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
