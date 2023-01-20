#! /bin/bash
# MEM

source ~/.profile
this=_screen
icon_color="^c#3B001B^^b#6873790x88^"
text_color="^c#3B001B^^b#6873790x99^"
signal=$(echo "^s$this^" | sed 's/_//')
#
update() {
    screen_icon="﬘"
    screen_text=$(echo $men_usage_rate | awk '{printf "%02d%", $1}')

    icon="$screen_icon"
    text="$screen_text"

    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

notify() {
    free_result=`free -h`
    text="
Avail:\t $(echo "$free_result" | sed -n 2p | awk '{print $7}')
Total:\t $(echo "$free_result" | sed -n 2p | awk '{print $3}')/$(echo "$free_result" | sed -n 2p | awk '{print $2}')
Swap:\t $(echo "$free_result" | sed -n 3p | awk '{print $3}')/$(echo "$free_result" | sed -n 3p | awk '{print $2}')
"
   notify-send "" "" -r 9100
}

click() {
    case "$1" in
        L) notify ;;
        M) ;;
        R) call_htop ;;
        U) ;;
        D) ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
