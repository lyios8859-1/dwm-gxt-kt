#! /bin/bash
# 电池电量

source ~/.profile
this=_bat
# icon_color="^c#3B001B^^b#4865660x88^"
# icon_color="^c#ffffff^^b#00b5b80x99^"
text_color="^c#4169e1^^b#7fffd40x99^"
icon_color="^c#4169e1^^b#7fffd40x99^"
signal=$(echo "^s$this^" | sed 's/_//')

function complement(){
#use : VAR=`complement ${VAR} n`
 busilength=$(echo ${1}|awk '{print length($0)}')
 let freelength=${2}-${busilength}
 busispace=$(seq -s " " $[${freelength}+1]|sed 's/[0-9]//g')
 echo -e "${1}${busispace}"
}

update() {
    #bat_text=$(acpi -b | sed 2d | awk '{print $4}' | grep -Eo "[0-9]+")
    #[ ! "$bat_text" ] && bat_text=$(acpi -b | sed 2d | awk '{print $5}' | grep -Eo "[0-9]+")
   # if   [ "$bat_text" -ge 95 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 90 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 80 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 70 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 60 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 50 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 40 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 30 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 20 ]; then bat_icon="";
   # elif [ "$bat_text" -ge 10 ]; then bat_icon="";
   # else bat_icon=""; fi

charge_sta="$(acpi | sed 's/^Battery 0: //g' | awk -F ',' '{print $1}')"
bat_text=$(acpi -b | sed 2d | awk '{print $4}' | grep -Eo "[0-9]+")
[ ! "$bat_text" ] && bat_text=$(acpi -b | sed 2d | awk '{print $5}' | grep -Eo "[0-9]+")

if [ "${charge_sta}" == "Discharging" ] ;
then 
	charge_icon=""; 
	#echo "Discharging";
    if   [ "$bat_text" -ge 95 ]; then bat_icon="";
    elif [ "$bat_text" -ge 90 ]; then bat_icon="";
    elif [ "$bat_text" -ge 80 ]; then bat_icon="";
    elif [ "$bat_text" -ge 70 ]; then bat_icon="";
    elif [ "$bat_text" -ge 60 ]; then bat_icon="";
    elif [ "$bat_text" -ge 50 ]; then bat_icon="";
    elif [ "$bat_text" -ge 40 ]; then bat_icon="";
    elif [ "$bat_text" -ge 30 ]; then bat_icon="";
    elif [ "$bat_text" -ge 20 ]; then bat_icon="";
    elif [ "$bat_text" -ge 10 ]; then bat_icon="";
    else bat_icon="󱃍"; fi
elif [ "$charge_sta" == "Charging" ] ;
then
	charge_icon=""; 
	#echo "Charging";
    if   [ "$bat_text" -ge 95 ]; then bat_icon="󰂅";
    elif [ "$bat_text" -ge 90 ]; then bat_icon="󰂋";
    elif [ "$bat_text" -ge 80 ]; then bat_icon="󰂊";
    elif [ "$bat_text" -ge 70 ]; then bat_icon="󰢞";
    elif [ "$bat_text" -ge 60 ]; then bat_icon="󰂉";
    elif [ "$bat_text" -ge 50 ]; then bat_icon="󰢝";
    elif [ "$bat_text" -ge 40 ]; then bat_icon="󰂈";
    elif [ "$bat_text" -ge 30 ]; then bat_icon="󰂇";
    elif [ "$bat_text" -ge 20 ]; then bat_icon="󰂆";
    elif [ "$bat_text" -ge 10 ]; then bat_icon="󰢜";
    else bat_icon="󰢟"; fi
elif [ "$charge_sta" == "Full" ] ;
then
    bat_icon="󰂅";
else
    bat_icon="󰂑";
fi

    icon=" $bat_icon"
    text="$bat_text% "

    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

notify() {
    update
    _status="状态: $(acpi | sed 's/^Battery 0: //g' | awk -F ',' '{print $1}')"
    _remaining="剩余: $(acpi | sed 's/^Battery 0: //g' | awk -F ',' '{print $2}' | sed 's/^[ ]//g')"
    _time="可用时间: $(acpi | sed 's/^Battery 0: //g' | awk -F ',' '{print $3}' | sed 's/^[ ]//g' | awk '{print $1}')"
    [ "$_time" = "可用时间: " ] && _time=""
    notify-send "$bat_icon Battery" "\n$_status\n$_remaining\n$_time" -r 9530
}

click() {
    case "$1" in
        L) notify ;;
        R) killall xfce4-power-manager-settings || xfce4-power-manager-settings & ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
