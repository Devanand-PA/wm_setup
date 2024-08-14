/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
#include "movestack.c"

/* appearance */
static const char *fonts[]          = { 
	"JetBrains Mono:size=10:style=Bold",
//	"JetBrains Mono Nerd Font:size=11",
	"Noto Color Emoji:size=9" };
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 1;       /* snap pixel */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 0;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */


#include "colors.h"

static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
       [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
	[SchemeTitle]  = { dwm_titlefg, dwm_titlebg,  "#000000"  },
 };







/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9","📧" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      	instance    	title       tags mask     isfloating  isterminal	noswallow monitor */
	//{ "Gimp",     NULL,       	NULL,	0,      	1,		0, 		0,		-1 },
	{ "Floating_window",     NULL,       	NULL,	0,      	1,		0, 		0,		-1 },
//	{ "Conky",     NULL,       	NULL,	0,      	True,		0, 		0,		-1 },
//	{ "zice",     	NULL,       	NULL,	0,        	1,		0, 		1,		-1 },
//	{ "Zutty",     	NULL,       	NULL,	0,		1,		0, 		1,		-1 },
//	{ "Blender",    NULL,       	NULL,	0,            	0,       	0, 		1,		-1 },
	{ "st-fzf",     NULL,       	NULL,	0,            	0,        	1, 		0,		-1 },
	{ "imv",	NULL,       	NULL,	0,            	0,        	0, 		1,		-1 },
	{ "st-applet",	NULL,       	NULL,	0,            	1,        	0, 		0,		-1 },
	{ "st",     NULL,       	NULL,	0,            	0,        	1, 		0,		-1 },
//	{ "Alacritty",  NULL,		NULL, 	0,		0,		1,	 	0,		-1 },
//	{ "Firefox",  	NULL,       	NULL,	1 << 8,	       	0,          	0, 		0,		-1 },
	{ "thunderbird",  	NULL,       	NULL,	1 << 9,	       	0,          	0, 		0,		-1 },
//	{ "thunderbird",NULL,   	NULL,	1 << 8,	       	0,          	0, 		0,		-1 },
};

/* layout(s) */
static const float mfact     = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1
#include "nrowgrid.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "☁",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "🪟",      nrowgrid },
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
#define TERM "st"
/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon,NULL };
//Terminal spawned
static const char *searchcmd[]  = { "st","-c","st-fzf", "-e" , "filsrc","-m=fzf", NULL };
//
static const char *window_switcher_rofi[]  = { "rofi", "-show", "window" ,"-show-icons",  "-font", "JetBrains Mono 12" ,"-kb-row-down" ,"Alt+Tab", NULL };
// static const char *window_switcher_rofi[]  = { "window_switcher" , NULL };
static const char *brightnesscmd[][4] = {{"sh","-c","brightnessctl set 50- && chbright", NULL},{"sh","-c","brightnessctl set 50+ && chbright", NULL}};
static const char *volumekeys[][8] = { {"sh","-c","amixer -D pulse set Master 1+ toggle && chvol",NULL},{"sh","-c","amixer -D pulse set Master 1+ unmute && amixer -q sset 'Master' 2%+ && chvol",NULL},{"sh","-c","amixer -D pulse set Master 1+ unmute && amixer -q sset 'Master' 2%- && chvol",NULL}};
//static const char *volumekeys[][8] = {{"pactl","set-sink-mute","3","toggle",NULL},{"pactl","set-sink-volume","3","+1%",NULL},{"pactl","set-sink-volume","3","-1%",NULL}};
static const char *applet_Command[]  = { "st","-f","JetBrains Mono:size=12","-e","applet_selector" ,NULL };
static const char *screenshot[][3] = {{"screenshot",NULL},{"screenshot","-s",NULL}};

//
//
static const Key keys[] = {
	/* modifier                     key     			function        argument */
	{ MODKEY,                       XK_space,			spawn,          {.v = dmenucmd } },
	{ MODKEY|ControlMask,           XK_c,				spawn,          SHCMD("xclip -o | xclip -sel clip") },
	{ MODKEY,	                XK_x, 				spawn,          {.v = (const char*[]){TERM, NULL} } },
	{ MODKEY,	                XK_v, 				spawn,          {.v = (const char*[]){"pcmanfm", NULL} } },
	{ MODKEY|Mod1Mask,              XK_x, 				spawn,          {.v = (const char*[]){"tabbed","-k","st","-w" , NULL} } },
	{ MODKEY,			XK_t,				spawn,		{.v = (const char*[]){"st","-e","calcurse" , NULL} } },
	{ MODKEY,	                XK_s, 				spawn,          {.v = searchcmd } },
	{ MODKEY|Mod1Mask,	        XK_s, 				spawn,          {.v = (const char*[]){"bookmarks","save",NULL} } },
	{ MODKEY|Mod1Mask,	        XK_b, 				spawn,          {.v = (const char*[]){"bookmarks","output",NULL} } },
	{ MODKEY|ShiftMask,		XK_s, 				spawn,          {.v = applet_Command } },
	{ MODKEY,			XK_w, 				spawn,          {.v = (const char*[]){"vscrot","I",NULL} } },
	{ MODKEY,			XK_r, 				spawn,          {.v = (const char*[]){"st","-e","pickup","-r",NULL} } },
	{ MODKEY,	                XK_e, 				spawn,          {.v = (const char*[]){"emoji.sh", NULL} } },
	{ MODKEY|ControlMask,	        XK_m, 				spawn,          {.v = (const char*[]){"firefox","-P","Mail",NULL} } },
	{ MODKEY,	                XK_m, 				spawn,          {.v = (const char*[]){"thunderbird",NULL} } },
	{ MODKEY|Mod1Mask,	        XK_m, 				spawn,          {.v = (const char*[]){"firefox","-P","Manga",NULL} } },
	{ MODKEY,	                XK_n, 				spawn,          {.v = (const char*[]){"st","-e","nvim",NULL} } },
	{ MODKEY|Mod1Mask,		XK_r,   			quit,           {1} }, 
//	{ MODKEY,			XK_r,   			quit,           {1} }, 
	{ MODKEY,	                XK_p, 				spawn,          {.v = (const char*[]){"firefox","--private-window",NULL} } },
	{ MODKEY|ShiftMask,	        XK_p, 				spawn,          {.v = (const char*[]){"librewolf",NULL} } },
	{ Mod1Mask,		XK_Tab, 			spawn,          {.v = window_switcher_rofi} },
	{ MODKEY,	                XK_b, 				spawn,          {.v = (const char*[]){"brave-browser",NULL} } },
	{ MODKEY,			XK_o, 				spawn,          SHCMD("cat ~/.xdg_open_history | dmenu -l 30 -i | xargs -I {} filsrc '{}' ") },
	{ MODKEY|ShiftMask,		XK_o, 				spawn,          {.v = (const char*[]){"obs","--minimize-to-tray",NULL} } },
	{ 0,		                XF86XK_MonBrightnessDown, 	spawn,		{.v = brightnesscmd[0] } },
	{ 0,		                XF86XK_MonBrightnessUp, 	spawn,  	{.v = brightnesscmd[1] } },
	{ 0,		                XF86XK_AudioMute, 		spawn,        	{.v = volumekeys[0] } },
	{ ShiftMask,	                XF86XK_AudioMute, 		spawn,        	{.v = (const char*[]){"vmscript",NULL} } },
	{ 0,		                XF86XK_AudioRaiseVolume, 	spawn, 		{.v = volumekeys[1] } },
	{ 0,		                XF86XK_AudioLowerVolume, 	spawn, 		{.v = volumekeys[2] } },
	{ 0,				XK_Print,			spawn,		{.v = screenshot[0] } },
	{ MODKEY,			XK_Print,			spawn,		{.v = screenshot[1] } },
	{ MODKEY|ShiftMask,             XK_b,      			togglebar, 	{0} },
	{ MODKEY,                       XK_j,      			focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      			focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      			incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      			incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      			setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      			setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, 			zoom,           {0} },
	{ MODKEY,                       XK_Tab,    			view,           {0} },
	{ MODKEY,	                XK_q,      			killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_t,      			setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_f,      			setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,             XK_g,      			setlayout,      {.v = &layouts[3]} },
	{ MODKEY|ShiftMask,             XK_j,      			movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      			movestack,      {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_m,      			setlayout,      {.v = &layouts[2]} },
//	{ MODKEY|ShiftMask,             XK_f,      			setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  			togglefloating, {0} },
	{ MODKEY,                       XK_0,      			view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      			tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  			focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, 			focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  			tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, 			tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,      			          	0)
	TAGKEYS(                        XK_2,      			          	1)
	TAGKEYS(                        XK_3,      			          	2)
	TAGKEYS(                        XK_4,      			          	3)
	TAGKEYS(                        XK_5,      			          	4)
	TAGKEYS(                        XK_6,      			          	5)
	TAGKEYS(                        XK_7,      			          	6)
	TAGKEYS(                        XK_8,      			          	7)
	TAGKEYS(                        XK_9,      			           	8)
	TAGKEYS(                        XK_F1,      			           	9)
	{ MODKEY|Mod1Mask,             	XK_q,      			quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = applet_Command } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

