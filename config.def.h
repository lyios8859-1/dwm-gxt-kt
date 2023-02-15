#include <X11/XF86keysym.h>

static int showsystray                   = 1;         /* 是否显示托盘栏 */
static const int newclientathead         = 0;         /* 定义新窗口在栈顶还是栈底 */
static const unsigned int borderpx       = 5;         /* 窗口边框大小 */
static const unsigned int systraypinning = 1;         /* 托盘跟随的显示器 0代表不指定显示器 */
static const unsigned int systrayspacing = 1;         /* 托盘间距 */
static const unsigned int systrayspadding = 5;        /* 托盘和状态栏的间隙 */
static int gappi                         = 15;        /* 窗口与窗口 缝隙大小 */
static int gappo                         = 15;        /* 窗口与边缘 缝隙大小 */
static const int _gappo                  = 15;        /* 窗口与窗口 缝隙大小 不可变 用于恢复时的默认值 */
static const int _gappi                  = 15;        /* 窗口与边缘 缝隙大小 不可变 用于恢复时的默认值 */
static const int vertpad                 = 3;         /* vertical padding of bar */
static const int sidepad                 = 3;         /* horizontal padding of bar */
static const int overviewgappi           = 24;        /* overview时 窗口与边缘 缝隙大小 */
static const int overviewgappo           = 60;        /* overview时 窗口与窗口 缝隙大小 */
static const int showbar                 = 1;         /* 是否显示状态栏 */
static const int topbar                  = 1;         /* 指定状态栏位置 0底部 1顶部 */
static const float mfact                 = 0.5;       /* 主工作区 大小比例 */
static const int   nmaster               = 1;         /* 主工作区 窗口数量 */
static const unsigned int snap           = 10;        /* 边缘依附宽度 */
static const unsigned int baralpha       = 0xc0;      /* 状态栏透明度 */
static const unsigned int borderalpha    = 0xdd;      /* 边框透明度 */
static const char *fonts[]               = {
//"monospace:size=15",
			"Monaco:style=Regular:size=11",
			"Symbols Nerd Font:style=2048-em:size=17",
		  "Microsoft YaHei:size=11:style=Regular:antialias=true:autohint:true",
			"JoyPixels:size=13:antialias=true:autohint=true"
};
static const char *colors[][3]           = {          /* 颜色设置 ColFg, ColBg, ColBorder */ 
    [SchemeNorm] = { "#ffffff", "#333333", "#444444" },
    [SchemeSel] = { "#ffffff", "#47575F", "#abd687" },
    [SchemeSelGlobal] = { "#ffffff", "#47575F", "#f09a7f" },
    [SchemeHid] = { "#dddddd", NULL, NULL },
    [SchemeSystray] = { NULL, "#7799AA", NULL },
    [SchemeUnderline] = { "#fcf86f", NULL, NULL }, 
    [SchemeNormTag] = { "#aaaaaa", "#333333", NULL },
    [SchemeSelTag] = { "#eeeeee", "#333333", NULL },
    [SchemeBarEmpty] = { NULL, "#111111", NULL },
};
static const unsigned int alphas[][3]    = {          /* 透明度设置 ColFg, ColBg, ColBorder */ 
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha }, 
    [SchemeSel] = { OPAQUE, baralpha, borderalpha },
    [SchemeSelGlobal] = { OPAQUE, baralpha, borderalpha },
    [SchemeNormTag] = { OPAQUE, baralpha, borderalpha }, 
    [SchemeSelTag] = { OPAQUE, baralpha, borderalpha },
    [SchemeBarEmpty] = { NULL, 0xa0a, NULL },
    [SchemeStatusText] = { OPAQUE, 0x88, NULL },
};


/* 防止误关闭，一些程序关闭快捷键不会响应 */
static const char *disablekillclient[] = {
  "wemeetapp", // 腾讯会议顶栏
  "tmux", // tmux不要误关了，防止有子窗口还在运行
  "QQ", // QQ关闭后会直接退出,不会最小化,微信不需要这个操作
};

/* 自定义脚本位置 */
// static const char *autostartscript = "/home/gxt_kt/my_desktop/dwm/autostart/autostart.sh";
static const char *autostartscript = "~/my_desktop/dwm/autostart/autostart.sh";
static const char *statusbarscript = "~/my_desktop/dwm/statusbar/statusbar.sh";//gxt_kt

/* 自定义 scratchpad instance */
static const char scratchpadname[] = "scratchpad";

/* 自定义tag名称 */
/* 自定义特定实例的显示状态 */
//            ﮸  ﭮ 切
//            
// 对应的tag序号以及快捷键:   0:1  1:2  2:3  3:4  4:5  5:9  6:c  7:m  8:0  9:w 10:l
//static const char *tags[] = { "", "", "", "", "5", "6", "7", "8", "9" };
static const char *tags[] = { "", "", "", "", "", "󰤚","", "","","" };
//static const char *tags[] = { "", "","","", "","","", "","﬐","" };
//static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

/* Lockfile */
static char lockfile[] = "/tmp/dwm.lock"; // doublepressquitPatch

/* W-C-S-E 热重启dwm后不会重复执行autostart脚本 */
static const char* avoid_repeat_auto_start = "/tmp/dwm_avoid_repeat_auto_start.lock"; // doublepressquitPatch

// restoreafterrestart
#define SESSION_FILE "/tmp/dwm-session"
#define SESSION_TAG_FILE "/tmp/dwm-tag-session"

static const Rule rules[] = {
    /* class                 instance              title             tags mask     isfloating  isglobal    isnoborder monitor */
    //{"demotest",                  NULL,                 NULL,             1 << 5,       0,          0,          0,        -1 },
    {"obs",                  NULL,                 NULL,             1 << 5,       0,          0,          0,        -1 },
    {"chrome",               NULL,                 NULL,             1 << 6,       0,          0,          0,        -1 },
    {"Chromium",             NULL,                 NULL,             1 << 6,       0,          0,          0,        -1 },
    {"music",             NULL,             NULL,             1 << 7,       0,          0,          0,        -1 },
    {"wemeetapp",            NULL,                 NULL,             TAGMASK,      1,          1,          0,        -1 }, // 腾讯会议在切换tag时有诡异bug导致退出 变成global来规避该问题
    {"copyq",            NULL,                 NULL,             TAGMASK,      1,          1,          0,        -1 }, 
    {"Nitrogen",            NULL,                 NULL,             TAGMASK,      1,          0,          0,        -1 }, 
    {"钉钉",            NULL,                 NULL,             TAGMASK,      1,          1,          0,        -1 }, // 腾讯会议在切换tag时有诡异bug导致退出 变成global来规避该问题
    {"dingtalk",            NULL,                 NULL,             TAGMASK,      1,          1,          0,        -1 }, // 腾讯会议在切换tag时有诡异bug导致退出 变成global来规避该问题
    {"com.alibabainc.dingtalk",            NULL,                 NULL,             TAGMASK,      1,          1,          0,        -1 }, // 腾讯会议在切换tag时有诡异bug导致退出 变成global来规避该问题
    {"tblive",            NULL,                 NULL,             TAGMASK,      1,          1,          0,        -1 }, // 腾讯会议在切换tag时有诡异bug导致退出 变成global来规避该问题
    { NULL,          NULL,          "图片查看",       TAGMASK ,            1,          0,          0,        -1 },  // qq image preview title
    { NULL,          NULL,          "Image Preview",   TAGMASK ,            1,          0,          0,        -1 }, //wechat image preview title
    // { NULL,          NULL,          "broken",      TAGMASK,            1,          0,          0,        -1 }, // qq upload file's win is broken
    // { NULL,          NULL,           "图片预览",        0,            1,          0,          0,        -1 },
  //  {"music",                NULL,                 NULL,             1 << 7,       1,          0,          1,        -1 },
  //  { NULL,                 "qq",                  NULL,             1 << 8,       0,          0,          1,        -1 },
  //  { NULL,                 "wechat.exe",          NULL,             1 << 9,       0,          0,          0,        -1 },
  //  { NULL,                 "wxwork.exe",          NULL,             1 << 10,      0,          0,          0,        -1 },
    //{ NULL,                  NULL,                "broken",          0,            1,          0,          0,        -1 },
    //{ NULL,                  NULL,                "crx_",            0,            1,          0,          0,        -1 },
  //  {"flameshot",            NULL,                 NULL,             0,            1,          0,          0,        -1 },
      /** 部分特殊class的规则 */
    {"FG",                   NULL,                 NULL,             TAGMASK,      1,          1,          1,        -1 }, // 浮动 + 全局
    {"FN",                   NULL,                 NULL,             0,            1,          0,          1,        -1 }, // 浮动 + 无边框
    {"GN",                   NULL,                 NULL,             TAGMASK,      0,          1,          1,        -1 }, // 全局 + 无边框
    {"FGN",                  NULL,                 NULL,             TAGMASK,      1,          1,          1,        -1 }, // 浮动 + 全局 + 无边框
                                                                                                                           
                                                                                                                           //
    {"float",                NULL,                 NULL,             0,            1,          0,          0,        -1 }, // 浮动
    {"noborder",             NULL,                 NULL,             0,            0,          0,          1,        -1 }, // 无边框
    {"global",               NULL,                 NULL,             TAGMASK,      0,          1,          0,        -1 }, // 全局
};
static const char *overviewtag = "OVERVIEW";
static const Layout overviewlayout = { "",  overview };
//﬿
/* 自定义布局 */
#include "gaplessgrid.c"
static const Layout layouts[] = {
  /* symbol     arrange function */
    { "﬿",  tile },         /* 主次栈 */
    { "﩯", magicgrid },    /* 网格 */
    { "|1|", tile_right }, /* actually not use*/
    { "|2|",      gaplessgrid }, /* actually not use*/
	  { NULL,       NULL },
    //{ "[M]",      monocle },
};

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG, cmd) \
    { MODKEY,              KEY, view,       {.ui = 1 << TAG, .v = cmd} }, \
    { MODKEY|ShiftMask,    KEY, tag,        {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,  KEY, toggleview, {.ui = 1 << TAG} }, \

static Key keys[] = {
    /* modifier            key              function          argument */
    //{ MODKEY,              XK_equal,        togglesystray,    {0} },                     /* super +          |  切换 托盘栏显示状态 */

    { Mod1Mask,            XK_Tab,          focusstack,       {.i = +1} },               /* alt tab            |  本tag内切换聚焦窗口 */
    { Mod1Mask|ShiftMask,  XK_Tab,          focusstack,       {.i = -1} },               /* alt shift tab      |  本tag内切换聚焦窗口 */
    { MODKEY,              XK_Tab,          toggleoverview,   {0} },                     /* super a            |  显示所有tag 或 跳转到聚焦窗口的tag */

    //{ MODKEY,              XK_Up,           focusstack,       {.i = -1} },               /* super up         |  本tag内切换聚焦窗口 */
    //{ MODKEY,              XK_Down,         focusstack,       {.i = +1} },               /* super down       |  本tag内切换聚焦窗口 */

    // { MODKEY,               XK_j,      focusstack,     {.i = +1 , .focus_win='L'} }, /* 本tag内切换聚焦窗口 */
    // { MODKEY,               XK_k,      focusstack,     {.i = -1 , .focus_win='H'}}, /* 本tag内切换聚焦窗口 */
    // { MODKEY,               XK_h,      focusstack,     {.focus_win='H'} }, /* 本tag内切换聚焦窗口 */
    // { MODKEY,               XK_j,      focusstack,     {.focus_win='J'} }, /* 本tag内切换聚焦窗口 */
    // { MODKEY,               XK_k,      focusstack,     {.focus_win='K'} }, /* 本tag内切换聚焦窗口 */
    // { MODKEY,               XK_l,      focusstack,     {.focus_win='L'} }, /* 本tag内切换聚焦窗口 */
  	{ MODKEY,                XK_h,   focusdir,       {.i = 0 } }, // left
  	{ MODKEY,                XK_j,   focusdir,       {.i = 1 } }, // down 
  	{ MODKEY,                XK_k,   focusdir,       {.i = 2 } }, // up
  	{ MODKEY,                XK_l,   focusdir,       {.i = 3 } }, // right
    // { MODKEY|ShiftMask,     XK_j,      rotatestack,    {.i = +1 } }, /* rotate the stack*/
    // { MODKEY|ShiftMask,     XK_k,      rotatestack,    {.i = -1 } }, /* rotate the stack*/


    { MODKEY|ShiftMask,    XK_h,            ExchangeClient,           {.i = 0} },               /* super shift b      |  将聚焦窗口移动到另一个显示器 */
    { MODKEY|ShiftMask,    XK_j,      ExchangeClient,    {.i = 1 } }, /* rotate the stack*/
    { MODKEY|ShiftMask,    XK_k,      ExchangeClient,    {.i = 2 } }, /* rotate the stack*/
    { MODKEY|ShiftMask,    XK_l,            ExchangeClient,           {.i = 3} },               /* super shift b      |  将聚焦窗口移动到另一个显示器 */

    // { MODKEY|ShiftMask,              XK_Left,         viewtoleft,       {0} },                     /* super left         |  聚焦到左边的tag */
    // { MODKEY|ShiftMask,              XK_Right,        viewtoright,      {0} },                     /* super right        |  聚焦到右边的tag */
    
    // { MODKEY|ShiftMask,     XK_Left,         tagtoleft,        {0} },                     /* super shift left   |  将本窗口移动到左边tag */
    // { MODKEY|ShiftMask,     XK_Right,        tagtoright,       {0} },                     /* super shift right  |  将本窗口移动到右边tag */

    { MODKEY,              XK_comma,        setmfact,         {.f = -0.05} },            /* super ,            |  缩小主工作区 */
    { MODKEY,              XK_period,       setmfact,         {.f = +0.05} },            /* super .            |  放大主工作区 */

    { MODKEY,              XK_d,            hidewin,          {0} },                     /* super h            |  隐藏 窗口 */
    { MODKEY|ShiftMask,    XK_d,            restorewin,       {0} },                     /* super shift h      |  取消隐藏 窗口 */

    { MODKEY|ShiftMask,    XK_Return,       zoom,             {0} },                     /* super shift enter  |  将当前聚焦窗口置为主窗口 */


    { MODKEY,              XK_f,            togglefloating,   {0} },                     /* super f            |  开启/关闭 聚焦目标的float模式 */
    { MODKEY|ShiftMask,    XK_f,            toggleallfloating,{0} },                     /* super shift f      |  开启/关闭 全部目标的float模式 */

    { MODKEY,              XK_F11,          fullscreen,       {0} },                     /* super F11          |  开启/关闭 全屏 */
    { MODKEY,              XK_b,            togglebar,        {0} },                     /* super b            |  开启/关闭 状态栏 */

    { MODKEY,              XK_g,            toggleglobal,     {0} },                     /* super g            |  开启/关闭 全局 */
    { MODKEY,              XK_a,            incnmaster,       {.i = +1} },               /* super a            |  改变主工作区窗口数量 (1 2中切换) */

    { MODKEY|Mod1Mask,              XK_Left,             focusmon,         {.i = -1} },               /* super b            |  光标移动到另一个显示器 */
    { MODKEY|Mod1Mask,              XK_Right,            focusmon,         {.i = +1} },               /* super b            |  光标移动到另一个显示器 */
    { MODKEY|Mod1Mask,              XK_h,             focusmon,         {.i = -1} },               /* super b            |  光标移动到另一个显示器 */
    { MODKEY|Mod1Mask,              XK_l,            focusmon,         {.i = +1} },               /* super b            |  光标移动到另一个显示器 */
    { MODKEY|ShiftMask,    XK_Left,            tagmon,           {.i = -1} },               /* super shift b      |  将聚焦窗口移动到另一个显示器 */
    { MODKEY|ShiftMask,    XK_Right,            tagmon,           {.i = +1} },               /* super shift b      |  将聚焦窗口移动到另一个显示器 */
    // { MODKEY|ShiftMask,    XK_h,            tagmon,           {.i = -1} },               /* super shift b      |  将聚焦窗口移动到另一个显示器 */
    // { MODKEY|ShiftMask,    XK_l,            tagmon,           {.i = +1} },               /* super shift b      |  将聚焦窗口移动到另一个显示器 */

    // win+q 关闭窗口容易误触，改成win+ctrl+q
    { MODKEY|ShiftMask,  XK_q,  killclient, {0} },   /* super q |  关闭窗口 */
    { MODKEY|ControlMask, XK_q, forcekillclient,  {0} },    /* super ctrl q |  强制关闭窗口(处理某些情况下无法销毁的窗口) */
    { MODKEY|ShiftMask, XK_Escape, quit, {0} },  /* super  shift  q    |  退出dwm */
    { MODKEY|ControlMask|ShiftMask, XK_Escape,    quit,            {1} },      		 /* super shift ctrl q | restart dwm*/

    // { MODKEY|ShiftMask,  XK_o,     selectlayout,     {.v = &layouts[0]} },      /* super shift space  |  切换到网格布局 */
    // { MODKEY|ControlMask,  XK_o,   selectlayout,     {.v = &layouts[1]} },      /* super shift space  |  切换到网格布局 */
  // It's just need to map one key to change layout between layouts[0] and layouts[1].
    { MODKEY|ShiftMask,  XK_z,   selectlayout,     {.v = &layouts[1]} },      /* super shift z  |  切换布局 */
    { MODKEY|ControlMask,  XK_z,   selectlayout,     {.v = &layouts[2]} },      /* super shift z  |  切换布局 */
	  { MODKEY|ShiftMask,      XK_comma, cyclelayout,    {.i = -1 } },
	  { MODKEY|ShiftMask,      XK_period, cyclelayout,    {.i = +1 } },
    { MODKEY,  XK_z,            showonlyorall,    {0} },                     /* super z            |  切换 只显示一个窗口 / 全部显示 */

    { MODKEY|ControlMask,  XK_equal,        setgap,           {.i = +6} },               /* super ctrl +       |  gap增大 */
    { MODKEY|ControlMask,  XK_minus,        setgap,           {.i = -6} },               /* super ctrl -       |  gap减小 */
    { MODKEY|ControlMask,  XK_BackSpace,    setgap,           {.i = 0} },                /* super ctrl space   |  gap重置 */

    { MODKEY,  XK_Up,           movewin,          {.ui = UP} },              /* super ctrl up      |  移动窗口 */
    { MODKEY,  XK_Down,         movewin,          {.ui = DOWN} },            /* super ctrl down    |  移动窗口 */
    { MODKEY,  XK_Left,         movewin,          {.ui = LEFT} },            /* super ctrl left    |  移动窗口 */
    { MODKEY,  XK_Right,        movewin,          {.ui = RIGHT} },           /* super ctrl right   |  移动窗口 */

    { MODKEY|ControlMask,     XK_Up,           resizewin,        {.ui = V_REDUCE} },        /* super alt up       |  调整窗口 */
    { MODKEY|ControlMask,     XK_Down,         resizewin,        {.ui = V_EXPAND} },        /* super alt down     |  调整窗口 */
    { MODKEY|ControlMask,     XK_Left,         resizewin,        {.ui = H_REDUCE} },        /* super alt left     |  调整窗口 */
    { MODKEY|ControlMask,     XK_Right,        resizewin,        {.ui = H_EXPAND} },        /* super alt right    |  调整窗口 */

    /* spawn + SHCMD 执行对应命令(已下部分建议完全自己重新定义) */

    { MODKEY,              XK_grave,      togglescratch,SHCMD("alacritty -t scratchpad --class floatingTerminal")  },  /* super s | 打开scratch终端   */
    { MODKEY,              XK_Return, spawn, SHCMD("alacritty") },                                             /* super enter      | 打开st终端             */
    { MODKEY|ShiftMask,    XK_n,  spawn, SHCMD("alacritty -t term-global --class globalingTerminal") },         /* super space      | 打开全局st终端         */
    { MODKEY,              XK_n,  spawn, SHCMD("alacritty -t term-float --class floatingTerminal") },          /* super space      | 打开浮动st终端         */
    { MODKEY,              XK_e,  spawn, SHCMD("alacritty -e ranger") },          /* super space      | 打开浮动st终端         */

    //{ MODKEY,              XK_d,      spawn, SHCMD("~/scripts/call_rofi.sh run") },                             /* super d          | rofi: 执行run          */
    //{ MODKEY|ShiftMask,    XK_d,      spawn, SHCMD("~/scripts/call_rofi.sh drun") },                            /* super shift d    | rofi: 执行drun         */
    //{ MODKEY,              XK_p,      spawn, SHCMD("~/scripts/call_rofi.sh custom") },                          /* super p          | rofi: 执行自定义脚本   */
    
    { MODKEY,                XK_s,        spawn, SHCMD("rofi -show drun -show-icons" ) },                                   /* super  p    | rofi: 执行window       */
    { MODKEY|ControlMask,    XK_s,        spawn, SHCMD("rofi -show run -show-icons") },                                   /* super  p    | rofi: 执行window       */
    
    // Notice that if you first use copyq , Remeber that config 1.disable tray show 2.Enable hidden mainwindow. Then you can use this better.
    { MODKEY,    XK_v,        spawn, SHCMD("copyq toggle") },                                   /* super  v    | need Copyq : show copyq window      */

    //{ MODKEY,              XK_F1,     spawn, SHCMD("pcmanfm") },                                                /* super F1         | 文件管理器             */
    //{ MODKEY,              XK_k,      spawn, SHCMD("~/scripts/blurlock.sh") },                                  /* super k          | 锁定屏幕               */
    //{ MODKEY|Mod1Mask,    XK_Up,     spawn, SHCMD("~/scripts/set_vol.sh up") },                                /* super shift up   | 音量加                 */
    //{ MODKEY|Mod1Mask,    XK_Down,   spawn, SHCMD("~/scripts/set_vol.sh down") },                              /* super shift down | 音量减                 */
    // { MODKEY|ShiftMask,    XK_a,      spawn, SHCMD("flameshot gui -c -p ~/Pictures/screenshots") },             /* super shift a    | 截图                   */
    { MODKEY|ShiftMask,    XK_s,      spawn, SHCMD("flameshot gui") },             /* super shift s    | 截图                   */
    //{ MODKEY|ShiftMask,    XK_k,      spawn, SHCMD("~/scripts/screenkey.sh") },                                 /* super shift k    | 打开键盘输入显示       */
    //{ MODKEY|ShiftMask,    XK_q,      spawn, SHCMD("kill -9 $(xprop | grep _NET_WM_PID | awk '{print $3}')") }, /* super shift q    | 选中某个窗口并强制kill */
    //{ ShiftMask|ControlMask, XK_c,    spawn, SHCMD("xclip -o | xclip -selection c") },                          /* super shift c    | 进阶复制               */
    { MODKEY|ControlMask,    XK_l,      spawn, SHCMD("~/my_desktop/dwm/i3lock/lock.sh") },   

    /* super key : 跳转到对应tag (可附加一条命令 若目标目录无窗口，则执行该命令) */
    /* super shift key : 将聚焦窗口移动到对应tag */
    /* key tag cmd */
    TAGKEYS(XK_1, 0,  0)
    TAGKEYS(XK_2, 1,  0)
    TAGKEYS(XK_3, 2,  0)
    TAGKEYS(XK_4, 3,  0)
    TAGKEYS(XK_5, 4,  0)
    TAGKEYS(XK_6, 5,  0)
    TAGKEYS(XK_7, 6,  0)
    TAGKEYS(XK_8, 7,  0)
    TAGKEYS(XK_9, 8,  0)
    TAGKEYS(XK_o, 5,  "obs")
    TAGKEYS(XK_c, 6,  "google-chrome-stable") // 6+1 = tag
    TAGKEYS(XK_m, 7,  "/opt/YesPlayMusic/yesplaymusic")
    //TAGKEYS(XK_0, 8,  "linuxqq")
    //TAGKEYS(XK_w, 9,  "/opt/apps/com.qq.weixin.deepin/files/run.sh")
    //TAGKEYS(XK_l, 10, "/opt/apps/com.qq.weixin.work.deepin/files/run.sh")
    
{ 0, XF86XK_AudioMute,        spawn, SHCMD("pamixer -t; /home/gxt_kt/my_desktop/dwm/statusbar/packages/vol.sh notify ") },
//{ 0, XF86XK_AudioRaiseVolume, spawn, SHCMD("pamixer --allow-boost -i 5; ") },
//{ 0, XF86XK_AudioLowerVolume, spawn, SHCMD("pamixer --allow-boost -d 5; ") },
{ 0, XF86XK_AudioRaiseVolume, spawn, SHCMD("pamixer -i 5; /home/gxt_kt/my_desktop/dwm/statusbar/packages/vol.sh notify ") },
{ 0, XF86XK_AudioLowerVolume, spawn, SHCMD("pamixer -d 5; /home/gxt_kt/my_desktop/dwm/statusbar/packages/vol.sh notify ") },
{ 0, XF86XK_AudioPause,       spawn, SHCMD("playerctl stop") },
{ 0, XF86XK_AudioPrev,        spawn, SHCMD("playerctl previous") },
{ 0, XF86XK_AudioNext,        spawn, SHCMD("playerctl next") },
{ 0, XF86XK_AudioPlay,        spawn, SHCMD("playerctl play") },
{ 0, XF86XK_AudioStop,        spawn, SHCMD("playerctl stop") },
{ 0, XF86XK_AudioStop,        spawn, SHCMD("playerctl stop") },
{ 0, XF86XK_MonBrightnessUp,  spawn, SHCMD("light -A 5; notify-send -r 9123 -h int:value:`light` -h string:hlcolor:#dddddd 'Backlight' " ) },
{ 0, XF86XK_MonBrightnessDown,  spawn, SHCMD("light -U 5; notify-send -r 9123 -h int:value:`light` -h string:hlcolor:#dddddd 'Backlight' " ) },

};
static Button buttons[] = {
    /* click               event mask       button            function       argument  */
    /* 点击窗口标题栏操作 */
    { ClkWinTitle,         0,               Button3,          hideotherwins, {0} },                                   // 右键         |  点击标题     |  隐藏其他窗口仅保留该窗口
    { ClkWinTitle,         0,               Button1,          togglewin,     {0} },                                   // 左键         |  点击标题     |  切换窗口显示状态
    /* 点击窗口操作 */
    { ClkClientWin,        MODKEY,          Button1,          movemouse,     {0} },                                   // super+左键  |  拖拽窗口     |  拖拽窗口
    { ClkClientWin,        MODKEY,          Button3,          resizemouse,   {0} },                                   // super+右键  |  拖拽窗口     |  改变窗口大小
    /* 点击tag操作 */
    { ClkTagBar,           0,               Button1,          view,          {0} },                                   // 左键        |  点击tag      |  切换tag
	{ ClkTagBar,           0,               Button3,          toggleview,    {0} },                                   // 右键        |  点击tag      |  切换是否显示tag
    { ClkTagBar,           MODKEY,          Button1,          tag,           {0} },                                   // super+左键  |  点击tag      |  将窗口移动到对应tag
    { ClkTagBar,           0,               Button4,          viewtoleft,    {0} },                                   // 鼠标滚轮上  |  tag          |  向前切换tag
	{ ClkTagBar,           0,               Button5,          viewtoright,   {0} },                                   // 鼠标滚轮下  |  tag          |  向后切换tag
															  //
                                                                                                                      //
    /* 点击bar空白处 */
//{ ClkBarEmpty,         0,               Button1,          spawn, SHCMD("~/scripts/call_rofi.sh window") },        // 左键        |  bar空白处    |  rofi 执行 window
    //{ ClkBarEmpty,         0,               Button3,          spawn, SHCMD("~/scripts/call_rofi.sh drun") },          // 右键        |  bar空白处    |  rofi 执行 drun
    
    /* 点击状态栏操作 */
    { ClkStatusText,       0,     Button1, clickstatusbar,{0} },   // 左键        |  点击状态栏   |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal L
    { ClkStatusText,       0,    Button2,  clickstatusbar,{0} },    // 中键        |  点击状态栏   |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal M
    { ClkStatusText,       0,    Button3,  clickstatusbar,{0} },    // 右键        |  点击状态栏   |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal R
    { ClkStatusText,       0,    Button4,  clickstatusbar,{0} },    // 鼠标滚轮上  |  状态栏       |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal U
    { ClkStatusText,       0,     Button5, clickstatusbar,{0} },   // 鼠标滚轮下  |  状态栏       |  根据状态栏的信号执行 ~/scripts/dwmstatusbar.sh $signal D
};
