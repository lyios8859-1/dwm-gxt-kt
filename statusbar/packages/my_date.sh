#! /bin/bash
# DATE 获取日期和时间的脚本
source ~/.profile

this=_my_date
icon_color="^c#4B005B^^b#7E51680x88^"
text_color="^c#4B005B^^b#7E51680x99^"
signal=$(echo "^s$this^" | sed 's/_//')

update() {
    time_text="$(date '+%m/%d %T')"
    icon=""
    text="$(date '+%m/%d %T')"

    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

notify() {
    _cal=$(cal --color=always | sed 1,2d | sed 's/..7m/<b><span color="#ff79c6">/;s/..27m/<\/span><\/b>/' )
    _todo=$(cat ~/.todo.md | sed 's/\(- \[x\] \)\(.*\)/<span color="#ff79c6">\1<s>\2<\/s><\/span>/' | sed 's/- \[[ |x]\] //')
    notify-send " Calendar" "\n$_cal\n$_todo" -r 9540
}

call_todo() {
    pid1=`ps aux | grep 'st -t statusutil' | grep -v grep | awk '{print $2}'`
    pid2=`ps aux | grep 'st -t statusutil_todo' | grep -v grep | awk '{print $2}'`
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    kill $pid1 && kill $pid2 || st -t statusutil_todo -g 50x15+$((mx - 200))+$((my + 20)) -c noborder -e nvim ~/.todo.md 
}

click() {
    case "$1" in
        L) notify ;;
        #R) call_todo ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
