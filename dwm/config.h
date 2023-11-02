/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
#include "movestack.c"

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 1;       /* snap pixel */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Liberation Mono:size=13" };
static const char dmenufont[]       = "Liberation Mono:size=13";
static const char col_1[]        = "#000000";
static const char col_2[]       = "#444444";
static const char col_3[]       = "#ff5555";
static const char col_4[]       = "#000000";
static const char col_5[]       = "#bb2222";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_3, col_1, col_2 },
	[SchemeSel]  = { col_4, col_5,  col_5  },
};

/* tagging */
static const char *tags[] = { "📖", "🌐", "🌿", "😜", "5", "6", "7", "🎮", "📧" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating  isterminal	noswallow monitor */
	//{ "Gimp",     NULL,       NULL,       0,            1,          0, 		0,		-1 },
	{ "zice",     NULL,       NULL,       0,            1,          0, 		1,		-1 },
	{ "zutty",     NULL,       NULL,       0,            1,          0, 		1,		-1 },
	{ "st",     NULL,       NULL,       0,            0,          1, 		0,		-1 },
//	{ "Firefox",  NULL,       NULL,       1 << 8,       0,          0, 		0,		-1 },
	{ "thunderbird",  NULL,   NULL,       1 << 8,       0,          0, 		0,		-1 },
};

/* layout(s) */
static const float mfact     = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_1, "-nf", col_3, "-sb", col_5, "-sf", col_4, NULL };
static const char *browsercmd[]={"firefox", NULL};
static const char *browser2cmd[]={"dolphin", NULL};
static const char *browser3cmd[]={"brave-browser", NULL};
static const char *mailcmd[]={"mail", NULL};
static const char *chatcmd[]={"chat", NULL};
static const char *notescmd[]={"notion", NULL};
static const char *termcmd[]  = { "st", NULL };
static const char *window_switcher_rofi[]  = { "rofi","-show","window", NULL };
static const char *searchcmd[]  = { "st","-e","sc", NULL };
static const char *searchemoji[]  = { "emoji.sh", NULL };
static const char *brightnesscmd[][4] = {{"brightnessctl","set","5%-", NULL},{"brightnessctl","set","5+%", NULL}};
static const char *volumekeys[][8] = {{"amixer","-D","pulse","set","Master","1+","toggle",NULL},{"amixer","-q","sset","'Master'","5%+",NULL},{"amixer","-q","sset","'Master'","5%-",NULL}};
static const char *screenshot[][3] = {{"screenshot",NULL},{"screenshot","-s",NULL}};
static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_space,      spawn,          {.v = dmenucmd } },
	{ MODKEY,	                XK_x, spawn,          {.v = termcmd } },
	{ MODKEY,	                XK_s, spawn,          {.v = searchcmd } },
	{ MODKEY,	                XK_e, spawn,          {.v = searchemoji } },
	{ MODKEY,	                XK_m, spawn,          {.v = mailcmd } },
	{ MODKEY,	                XK_Return, spawn,          {.v = notescmd } },
	{ Mod1Mask,                       XK_Tab,    spawn,          {.v = window_switcher_rofi} },
	{ MODKEY,	                XK_b, spawn,          {.v = browsercmd } },
	{ MODKEY|ShiftMask,             XK_v, spawn,          {.v = browser3cmd } },
	{ MODKEY,	                XK_c, spawn,          {.v = chatcmd } },
	{ 0,		                XF86XK_MonBrightnessDown, spawn,          {.v = brightnesscmd[0] } },
	{ 0,		                XF86XK_MonBrightnessUp, spawn,          {.v = brightnesscmd[1] } },
	{ 0,		                XF86XK_AudioMute, spawn,          {.v = volumekeys[0] } },
	{ 0,		                XF86XK_AudioRaiseVolume, spawn,          {.v = volumekeys[1] } },
	{ 0,		                XF86XK_AudioLowerVolume, spawn,          {.v = volumekeys[2] } },
	{ 0,				XK_Print,		spawn,		{.v = screenshot[0] } },
	{ MODKEY,			XK_Print,		spawn,		{.v = screenshot[1] } },
	{ MODKEY|ShiftMask,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,	                XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ShiftMask,             XK_p,      setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|Mod1Mask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

