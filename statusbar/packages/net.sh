#! /bin/bash

source ~/.profile
this=_net
icon_color="^c#3B001B^^b#4865660x88^"
text_color="^c#3B001B^^b#4865660x99^"

signal=$(echo "^s$this^" | sed 's/_//')

update_net() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$(( sum + i ))
    done
    cache=${XDG_CACHE_HOME:-$HOME/.cache}/${1##*/}
    [ -f "$cache" ] && read -r old < "$cache" || old=0
    printf %d\\n "$sum" > "$cache"
    printf %d\\n $(( sum - old ))
}


update() {
    icon=""
 RX=$(update_net /sys/class/net/[ew]*/statistics/rx_bytes)
 TX=$(update_net /sys/class/net/[ew]*/statistics/tx_bytes)

function complement(){
  busilength=$(echo ${1}|awk '{print length($0)}')
  let freelength=${2}-${busilength}
  busispace=$(seq -s " " $[${freelength}+1]|sed 's/[0-9]//g')
  echo -e "${1}${busispace}" 
}

# 换算单位
if [[ $RX -lt 1024 ]];then
    # 如果接收速率小于1024,则单位为B/s
    RX="${RX}B"
    RX=`complement ${RX} 8`
elif [[ $RX -gt 1048576 ]];then
    # 否则如果接收速率大于 1048576,则改变单位为MB/s
    #RX=$(echo $RX | awk '{printf "%.1f%s" ${1}/1048576 "MB/s"}')
    RX=$(echo $RX | awk '{printf "%.1fMB",$1/1048576}')
    RX=`complement ${RX} 8`
else
    # 否则如果接收速率大于1024但小于1048576,则单位为KB/s
    RX=$(echo $RX | awk '{printf "%.1fKB",$1/1024}')
    RX=`complement ${RX} 8`
   # RX=$(echo $RX | awk '{printf "%.1f%s" ${1}/1024 "KB/s"}')
fi

# 换算单位
if [[ $TX -lt 1024 ]];then
    # 如果发送速率小于1024,则单位为B/s
    TX="${TX}B"
    TX=`complement ${TX} 8`
elif [[ $TX -gt 1048576 ]];then
    # 否则如果发送速率大于 1048576,则改变单位为MB/s
    #TX=$(echo $TX | awk '{printf "%.1f%s" "${1}/1048576" "MB/s"}')
    TX=$(echo $TX | awk '{printf "%.1fMB",$1/1048576}')
    TX=`complement ${TX} 8`
else
    # 否则如果发送速率大于1024但小于1048576,则单位为KB/s
    TX=$(echo $TX | awk '{printf "%.1fKB",$1/1024}')
    TX=`complement ${TX} 8`
    #TX=$(echo $TX | awk '{printf "%.1f%s" "${1}/1024" "KB/s"}')
fi

#printf "🔼:$TX 🔽:$RX"
#
text="${TX}${RX}"
    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

notify() {
    update
 notify-send "↕️🌏网络流量模块" -r 9013
    #notify-send "test1111" "test2222"
}

click() {
    case "$1" in
        L) notify ;;
        R) notify ;;
        #M) notify ;;
        #U) notify ;;
        #D) notify ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
