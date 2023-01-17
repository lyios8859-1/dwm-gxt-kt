#! /bin/bash

source ~/.profile
this=_package # gxt_kt

icon_color="^c#3B001B^^b#4865660x88^"
text_color="^c#3B001B^^b#4865660x99^"

signal=$(echo "^s$this^" | sed 's/_//')


update() {
    icon="" # 
    #text=$(pacman -Qu | grep -Fcv "[ignored]" | sed "s/^/📦/;s/^📦0$/[Latest]/g")
    text=$(pacman -Qu | grep -Fcv "[ignored]" )
    #text=$(pacman -Qu | grep -Fcv "[ignored]" | sed "s/^/📦/g")

if [ ${text} -ne 0 ]
then
	ping -q -c 3 www.baidu.com > /dev/null && notify-send "🎁 提示" "有${text}个可用更新\n点击状态栏图标 () 开始更新" -r 1020
fi

    sed -i '/^export '$this'=.*$/d' $DWM/statusbar/temp
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $DWM/statusbar/temp
}

notify() {
    #update
ping -q -c 3 www.baidu.com > /dev/null || ( 
	notify-send "🎁 提示" "请检查你的网络连接(ping baidu.com)" ;
	exit ;
)

package_update=$(pacman -Qu | grep -Fcv "[ignored]" )

if [ ${package_update} -ne 0 ]
then
	notify-send "🎁 提示" "检查到${package_update}个可用更新包\n正在为您更新..." -r 1021 ;
	echo "gxt0818" | sudo -S  pacman -Syyuw --noconfirm || notify-send "错误,下载更新失败.检查你的网络连接, 或手动更新." -r 1023 ;
else
	notify-send "🎁 提示" "您的系统已经是最新版了" -r 1022
fi

update

}

click() {
    case "$1" in
        L) notify ;;
        #R) notify ;;
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
