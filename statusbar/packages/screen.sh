#! /bin/bash
# Screen 部分特殊的标记图标 这里是我自己用的，你用不上的话去掉就行
source ~/.profile



this=_screen
icon_color="^c#ffffff^^b#7b68ee0x88^"
text_color="^c#ffffff^^b#7b78ee0x99^"
signal=$(echo "^s$this^" | sed 's/_//')

update() {
    icons=("󰹑")
    #[ "$(sudo docker ps | grep 'v2raya')" ] && icons=(${icons[@]} "")
    #[ "$(bluetoothctl info 88:C9:E8:14:2A:72 | grep 'Connected: yes')" ] && icons=(${icons[@]} "")
    [ "$AUTOSCREEN" = "OFF" ] && icons=(${icons[@]} "ﴸ")
    
    icon=" $icons"
    CONNECTED_PORTS=$(xrandr | grep -w 'connected' | awk '{print $1}' | wc -l)
    CONNECTED_MONITORS=$(xrandr --Clientmonitors | sed 1d | awk '{print $4}' | wc -l)
    text=" ${CONNECTED_MONITORS}/${CONNECTED_PORTS} "

    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

GetAllScreenAndStatus() {
  eDP=`xrandr | rg "\beDP.*? .*? " -o`
  HDMI=`xrandr | rg "\bHDMI.*? .*? " -o`
  DP=`xrandr | rg "\bDP.*? .*? " -o`
}

notify() {
    # notify-send "󰹑 Screen Info"  "`xrandr`" -r 1291
    GetAllScreenAndStatus
    notify-send "󰹑 Screen Info"  "${eDP}\n${HDMI}\n${DP}" -r 1291
    # texts="" 
    # [ "$texts" != "" ] && notify-send "󰹑 Info" "$texts" -r 9527
}

CallMenu() {
    update
    notify
    case $(echo -e '4k(L)+2k(P)(R)(2.0)\n4k(L)+2k(P)(R)(1.75)\n4k(L)+2k(P)(R)(1.5)\n4k(S)+1k(S)(2)\n4k_Single' | rofi -dmenu -window-title Screen${CONNECTED_MONITORS}/${CONNECTED_PORTS}) in
        "4k(L)+2k(P)(R)(2.0)") 4k_L____2k_P_R_2_0;;
        "4k(L)+2k(P)(R)(1.75)") 4k_L____2k_P_R_1_75;;
        "4k(L)+2k(P)(R)(1.5)") 4k_L____2k_P_R_1_5 ;;
        "4k(S)+1k(S)(2)") 4k_S___1k_S_2_0 ;;
        "4k_Single") 4k_Single ;;
    esac
}

4k_L____2k_P_R_1_5() {
  xrandr --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --primary --mode 2560x1440 --rate 120 --scale 1.5x1.5 --pos 3840x0 --rotate normal \
  --output eDP-1-0 --mode 3840x2160 --rate 60 --dpi 192 --pos 0x0 --rotate normal
}
4k_L____2k_P_R_1_75() {
  xrandr --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --primary --mode 2560x1440 --rate 120 --scale 1.75x1.75 --pos 3840x0 --rotate normal \
  --output eDP-1-0 --mode 3840x2160 --rate 60 --dpi 192 --pos 0x0 --rotate normal
}

4k_L____2k_P_R_2_0() {
  xrandr --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --primary --mode 2560x1440 --rate 120 --scale 2.0x2.0 --pos 3840x0 --rotate normal \
  --output eDP-1-0 --mode 3840x2160 --rate 60 --dpi 192 --pos 0x0 --rotate normal
}

4k_S___1k_S_2_0() {
  xrandr --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --primary --mode 1920x1080 --rate 60 --scale 2x2 --pos 0x0 --rotate normal \
  --output eDP-1-0 --mode 3840x2160 --rate 60 --dpi 192 --pos 0x0 --rotate normal
}

4k_Single() {
  xrandr  --output DP-0 --off \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output HDMI-0 --off \
  --output eDP-1-0 --mode 3840x2160   --rate 60 --dpi 192 
}

click() {
    case "$1" in
        L) CallMenu ;;
        R) notify;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
