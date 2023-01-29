#! /bin/bash
source ~/.profile

this=_wifi
# icon_color="^c#000080^^b#0064000x88^"
# text_color="^c#000080^^b#0064000x99^"
icon_color="^c#222222^^b#ffff000x88^"
text_color="^c#222222^^b#ffff000x99^"
signal=$(echo "^s$this^" | sed 's/_//')

update() {
	wifi_icon="󱛏"
	if grep -xq 'up' /sys/class/net/w*/operstate 2>/dev/null ;
	then
	 	# has wifi connect
		wifi_signal=$(awk '/^\s*w/ { print int($3 * 100 / 70)}' /proc/net/wireless)
		if   [ "$wifi_signal" -ge 80 ]; then wifi_icon="󰤨";
		elif   [ "$wifi_signal" -ge 60 ]; then wifi_icon="󰤥";
		elif   [ "$wifi_signal" -ge 40 ]; then wifi_icon="󰤢";
		elif   [ "$wifi_signal" -ge 20 ]; then wifi_icon="󰤟";
		else wifi_icon="󰤯"; fi
	
	elif grep -xq 'down' /sys/class/net/w*/operstate 2>/dev/null ; 
	then
	 	# not connect or disable wifi
		grep -xq '0x1003' /sys/class/net/w*/flags && wifiicon="睊" || wifiicon="󰤬"
	fi

    	icon=" $wifi_icon"
    	text="$wifi_text "

    	sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    	printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

notify() {
    update
	if grep -xq 'up' /sys/class/net/w*/operstate 2>/dev/null ;
	then
		wifi_signal=$(awk '/^\s*w/ { print int($3 * 100 / 70)}' /proc/net/wireless)
		wifi_name=$(nmcli -t -f name,device connection show --active | grep wlan0 | cut -d\: -f1)
		notify-send "Wifi connected." "Wifi name : ${wifi_name}\nSignal strength : ${wifi_signal}" -r 1025
	
	elif grep -xq 'down' /sys/class/net/w*/operstate 2>/dev/null ; 
	then
	 	# not connect or disable wifi
		send_text=""
		grep -xq '0x1003' /sys/class/net/w*/flags && send_text="Wifi no connected" || send_text="The wifi device is disable, please cheack your wifi device"
		notify-send "${send_text}" "Press right buttom to open wifi connect tool.(nmtui)" -r 1024
	fi
}

call_network_tool() {
 	alacritty -t nmtui --class floatingTerminal -e nmtui
}

click() {
    case "$1" in
        L) notify ;;
        R) call_network_tool ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
