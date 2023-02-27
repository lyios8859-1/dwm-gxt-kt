# DWM

b站简单演示链接：[https://www.bilibili.com/video/BV1hY4y127ef](https://www.bilibili.com/video/BV1hY4y127ef)

**如果你的觉得这个DWM还不错，麻烦点个star，谢谢! 这会是对我最大的激励**

***

本仓库主要 fork 自yaoccc https://github.com/yaocccc/dwm 并修改了自己需要的内容

首先要感谢yaoccc的dwm,主要基于`e49d3b8`历史版本进行了修改


## 说在前面：

**dwm安装视频教程和statusbar快速扩展教程已经新建文件夹了，稍等**

1. 遇到安装问题可以直接提issue或者b站底下评论。

2. 遇到linux相关问题请优先自己搜索，没法解决再提问，（很大概率我也不会），和本仓库相关建议直接提问，没有必要试错

3. 如果你现在在用dwm，想做一些增强但是没法实现，也可以直接和我说，如果我觉得想法很精彩，在力所能及的范围内也会主动去做的

4. 复杂问题没法简单说的可以联系邮箱`gxt_kt@163.com`，或者访问[gxt-kt.cn](gxt-kt.cn)留言


## 本仓库修改内容

**相比原版修改主要内容为:**

> 1. 增加功能: win+hjkl可以直接聚焦窗口,和vim,tmux的操作逻辑类似. 
>
>    原生的是一维聚焦窗口,现在改成二维聚焦,更符合操作直觉
>
> 2. 增加功能：win+shift+hjkl二维交换窗口
>
> 3. 全部重构statusbar.sh实现，全部采用python实现
>    
>    采用python+多线程，使用多线程优化多子任务效率，可以实现同步多子任务1s刷新
>    
>    2022-02-27 再次优化了多线程执行，基本可以保证时间准确.
>
> 4. 增加功能:增加可以不允许普通kill掉程序 (仍然允许使用forcekill关闭程序)
>
>    比如使用tmux打开很多终端,为了防止手贱误关闭程序,可以把tmux加入到不允许普通kill保护中
> 
>    又或者打开腾讯会议共享桌面,开会等关键时刻,防止手贱把腾讯会议关了等等使用场景
>
> 5. 增加功能:原生支持键盘操作音量,屏幕亮度调整等
> 
> 6. 增加功能：可以切换历史tag,可以自定义追溯历史tag大小
>    
>    如果特别设置一下，可以在任意两个tag之间一键来回切换
> 
>    这个功能刚开始用也许感觉很鸡肋，后面适应了会感觉和vim二维操作一样，离不开了
>
> 6. 增加功能:优化热重启，在补丁基础上再次优化，不会重复执行autostart
>
> 7. 增加了一些补丁,并选择保留补丁特性，在补丁基础上进一步优化，包括但不限于: 
>    
>    - 连续两次激活按键关闭dwm才进行关闭,防止误触
>    - 热重启dwm 更改配置文件重新编译安装后可以直接重启dwm并保留当前已经打开窗口和布局
>    - 旋转堆栈 可以更改窗口显示顺序 （已经注释，需要手动启用）
>    - 添加flextile增强布局


**其它一些优化内容为：**
> 1. 增加右侧tile布局（需要手动启用,如果使用flex增强布局则已经默认启用）
> 
>     原版为左侧tile布局，增加右侧布局符合某些操作习惯
>
> 2. 彻底修复窗口隐藏和修复的bug 
>
>    之前有提过pr,但是后面发现特殊情况下scratchpad仍然会打断窗口恢复，现在这个仓库已经彻底修复，等有时间再去yaoccc那提个pr修复一下
>
> 3. 解决tag下没有窗口除了scratchpad仍然显示tag的bug 
>
>    比如tag2下打开scratchpad,但tag2没有别的其它窗口,状态栏仍然会显示tag2的图标

**其他一些次要修改内容为:**

> 1. 终端使用全部使用Alacritty,原版为st
> 2. 按键由于hjkl优化，改动较大，建议熟悉vim使用


## 使用注意事项

1. config.def.h 文件中调用一些，确保这些命令存在就行，（不存在也可以正常运行，只是缺少对应功能）

   测试方法为:手动复制命令到终端中执行,如果成功就没问题

2. statusbar.py 文件中根据需要注释相应的包，确保要使用的包pip安装了

3. 我自己dwm的路径为 `~/my_desktop/dwm` , 相关功能的启用需要修改到你们自己的路径.

   建议也先将dwm安装到和我一样的目录，后续再更改对应路径到你自己的



## 目前本仓库一些可以优化的地方

1. ~~statusbar中音量功能中加入了一个显示蓝牙设备剩余电量功能,但是目前没法稳定使用,一般在刚开始连接时可以正常检测到,后面就不行. 这个暂时解决不了,只能说暂时不使用功能,需要等待上游更新或arch内核更新. (arch的蓝牙经常不稳定)~~
  
    已经修复，采用其它途径获取蓝牙音量，目前还比较稳定
   

## 一些其它值得讲的点
1. 对于一些特殊按键不知道名字，可以在终端内执行`xev`，就可以显示当前所按按键详细信息
    比如`\`键叫做`XK_backclash`
    
2. 在statusbar中使用sudo没法输入密码，解决方法有很多种，不建议采用明文泄露密码，建议采用下面方法：
    比如pacman执行sudo不需要输入密码,在`/etc/sudoers`加入`${user} ALL=(ALL) NOPASSWD: /usr/bin/pacman`

3. 建议在各种高危尝试前，先使用`timeshift`备份
