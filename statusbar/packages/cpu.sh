#! /bin/bash
# CPU 获取CPU使用率和温度的脚本
#
source ~/.profile


this=_cpu
icon_color="^c#3E206F^^b#6E51760x88^"
text_color="^c#3E206F^^b#6E51760x99^"
signal=$(echo "^s$this^" | sed 's/_//')
#°C
function complement(){
#use : VAR=`complement ${VAR} n`
 busilength=$(echo ${1}|awk '{print length($0)}')
 let freelength=${2}-${busilength}
 busispace=$(seq -s " " $[${freelength}+1]|sed 's/[0-9]//g')
 echo -e "${1}${busispace}"
}


update() {
    #cpu_text=$(top -n 1 -b | sed -n '3p' | awk '{printf "%2d", 100 - $8}')
    #cpu_usage=`top -bn1 | awk '/Cpu/ { print $2}'`
    # cpu_text=${cpu_usage%.*}
    # echo "cpu_text"${cpu_text}
    cpu_text=`python3 ${DWM}/statusbar/get_data.py cpu_usage`
    if [[ ${cpu_text} -lt 50 ]];then
        icon="" #
    else
        icon="" #
    fi
    cpu_text=${cpu_text}"%"
    #temp_text=$(sensors | grep Tctl | awk '{printf "%d", $2}')  
    temp_text=$(( `cat /sys/class/thermal/thermal_zone0/temp` / 1000))
    #temp_text=`python3 ${DWM}/statusbar/get_data.py cpu_temp`
    cpu_text=`complement ${cpu_text} 3`
    text="$cpu_text$temp_text"

    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

notify() {
	#notify_text="Total usage:    "$(top -n 1 -b | sed -n '3p' | awk '{printf "%d%", 100 - $8}')
	notify-send "  CPU tops"  "$(ps axch -o cmd:15,%cpu --sort=-%cpu | head  | sed 's/$/&%/g')" -r 1014
}

#call_btop() {
    #pid1=`ps aux | grep 'alacritty -t statusutil' | grep -v grep | awk '{print $2}'`
    #pid2=`ps aux | grep 'alacritty -t statusutil_cpu' | grep -v grep | awk '{print $2}'`
    #mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    #my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    #kill $pid1 && kill $pid2 || st -t statusutil_cpu -g 82x25+$((mx - 328))+$((my + 20)) -c noborder -e btop
#}

call_htop() {
    alacritty -t statusutil --class floatingTerminal -e btop;
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
