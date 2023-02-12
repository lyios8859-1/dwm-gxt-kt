#! /bin/bash
# ICONS 部分特殊的标记图标 这里是我自己用的，你用不上的话去掉就行
source ~/.profile



this=_icons
icon_color="^c#222222^^b#A3BE8C0x88^"
text_color="^c#222222^^b#8FBCBB0x99^"
signal=$(echo "^s$this^" | sed 's/_//')
#
update() {
    icons=("  ")
    #[ "$(sudo docker ps | grep 'v2raya')" ] && icons=(${icons[@]} "")
    #[ "$(bluetoothctl info 88:C9:E8:14:2A:72 | grep 'Connected: yes')" ] && icons=(${icons[@]} "")
    [ "$AUTOSCREEN" = "OFF" ] && icons=(${icons[@]} "ﴸ")
    
    text="${icons[@]}"

    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

CallMenu() {
    case $(echo -e '⏻ Shutdown\n Reboot\n⏾ Sleep\n Lock' | rofi -dmenu -window-title power) in
        "⏻ Shutdown") shutdown -h now ;;
        " Reboot") reboot ;;
        # "⏾ Sleep") systemctl hibernate ;;
        "⏾ Sleep") notify-send "⏾ Sleep Error!" "Sleep cannot use now because of amdgpu driver.\nMay solve it later." -r 4040 ;;
        " Lock") ${DWM}/i3lock/lock.sh;; # need i3lock-color
    esac
}

ChangeWallpaper() {
  # feh --recrsive --bg-fill  --randomize ~/my_desktop/backgrouds/animation/* &
  nitrogen&
}

click() {
    case "$1" in
        L) CallMenu ;;
        R) ChangeWallpaper;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
