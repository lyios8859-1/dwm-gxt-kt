#! /bin/bash
source ~/.profile
touch ./temp

# 设置某个模块的状态 update cpu mem ...
update() {
    [ ! "$1" ] && refresh && return                                      # 当指定模块为空时 结束
    bash $DWM/statusbar/packages/$1.sh                                   # 执行指定模块脚本
    shift 1; update $*                                                   # 递归调用
}

# 处理状态栏点击
click() {
    [ ! "$1" ] && return                                                 # 未传递参数时 结束
    bash $DWM/statusbar/packages/$1.sh click $2                          # 执行指定模块脚本
    update $1                                                            # 更新指定模块
    refresh                                                              # 刷新状态栏
}

# 更新状态栏
refresh() {
   # 重置所有模块的状态为空
	# gxt_kt add first place
    _package='';
    _icons='';
    _wifi='';
    _cpu='';
    _mem='';
    _my_date='';
    _vol='';
    _bat='';
    _net='';
    source $DWM/statusbar/temp                                           # 从 temp 文件中读取模块的状态

    # gxt_kt add second place
    xsetroot -name "$_icons$_package$_net$_cpu$_mem$_wifi$_vol$_bat$_my_date"             # 更新状态栏
}

# 启动定时更新状态栏 不同的模块有不同的刷新周期 注意不要重复启动该func
cron() {
    let i=0
    while true; do
        to=()                                                            # 存放本次需要更新的模块

        sleep 1 &
	pid=$!
	# gxt_kt add third place
        [ $((i % 3600)) -eq 0 ]  && to=(${to[@]} package)
        [ $((i % 1)) -eq 0 ]  && to=(${to[@]} net)   
        [ $((i % 5)) -eq 0 ]  && to=(${to[@]} wifi)  
        [ $((i % 4)) -eq 0 ]  && to=(${to[@]} cpu )  
        [ $((i % 3)) -eq 0 ]  && to=(${to[@]} mem )  
        [ $((i % 2)) -eq 0 ]  && to=(${to[@]} vol )  
        [ $((i % 3600)) -eq 0 ]  && to=(${to[@]} icons)   
        [ $((i % 10)) -eq 0 ] && to=(${to[@]} bat)   
        [ $((i % 1)) -eq 0 ]   && to=(${to[@]} my_date)                     # 每1秒   更新 date
        update ${to[@]}    &                                              # 将需要更新的模块传递给 update
       	let i+=1
	wait "${pid}"
    done &
}

# cron 启动定时更新状态栏
# update 更新指定模块 `update cpu` `update mem` `update date` `update vol` `update bat` 等
# updateall 更新所有模块 | check 检查模块是否正常(行为等于updateall)
# * 处理状态栏点击 `cpu 按键` `mem 按键` `date 按键` `vol 按键` `bat 按键` 等
case $1 in
    cron) cron ;;
    update) shift 1; update $* ;;
    updateall|check) update icons wifi cpu mem my_date vol bat net package ;; # gxt_kt
    #updateall|check) update  net icons wifi my_date ;; # gxt_kt
    *) click $1 $2 ;; # 接收clickstatusbar传递过来的信号 $1: 模块名  $2: 按键(L|M|R|U|D)
esac
