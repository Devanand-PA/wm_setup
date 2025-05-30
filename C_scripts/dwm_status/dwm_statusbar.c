#include <stdio.h>
#include <time.h>
#include <string.h>
#include <X11/Xlib.h>
#include <unistd.h>
#include <stdlib.h>
//==================================
time_t rawtime;
struct tm * timeinfo;
char time_buffer[80];
FILE *file;
int battery_percentage;
char set_to_bar[100];
char charging_status[20];
char bat_icon[50] = "[No Battery]";
//===================================

//======================================
int battery_functions() {
	file = fopen("/sys/class/power_supply/BAT0/capacity", "r");
if (file == NULL) {
        printf("Error opening file.\n");
        return 1;
    }

fscanf(file, "%d", &battery_percentage);
fclose(file);

    file = fopen("/sys/class/power_supply/BAT0/status", "r");
    if (file == NULL) {
        printf("Error opening file.\n");
        return 1;
    }

    fscanf(file, "%s", charging_status);
    fclose(file);


static const char *BAT_ARRAY[] = {"🟥","🟥","🟧","🟧","🟨","🟨","🟩","🟩","🟦","🟦"};
//static const char *BAT_ARRAY[] = {"█","█","█","█","█","█","█","█","█","█"};

//This thing overwrites bat_10 if you don't give it atleast twice the memory because those coloured blocks are ""

int bat_10 = ((battery_percentage+5)/10.0) ;
sprintf(bat_icon,"[");

//int bat_10 = 8;

//printf("bat_10 is :");
//printf("%d\n",bat_10);
for(int i=0;i<bat_10;++i){
	//printf("The Value of i is:%d\n",i);
	//printf("bat_10 is %d\n",bat_10);
	sprintf(bat_icon,"%s%s",bat_icon,BAT_ARRAY[i]);
}
//printf("Done with battery blocks\n");
//printf("Battery Blocks are %s\n",bat_icon);
for(int i=0;i<(10-bat_10);++i)
{
	//printf("The Value of i is:%d\n",i);
	//printf("bat_10 is %d\n",bat_10);
	sprintf(bat_icon,"%s⬛", bat_icon);
}
//printf("Done with battery blocks\n");
//printf("Battery Blocks are %s\n",bat_icon);
sprintf(bat_icon,"%s]", bat_icon);
if (strcmp(charging_status, "Discharging") == 0) {
	sprintf(bat_icon,"%s⏬", bat_icon);
}
else {
	sprintf(bat_icon,"%s⚡", bat_icon);
}

}





int display_titlebar_x() {
// Time
time(&rawtime);
timeinfo = localtime(&rawtime);
strftime(time_buffer, sizeof(time_buffer), "%a %d %b %I:%M %p", timeinfo);
//=============================================
// Battery

battery_percentage = 0;
if( access( "/sys/class/power_supply/BAT0/capacity", F_OK ) == 0 ) {
		printf("\nBat exists\n");
battery_functions();
  // file exists
} else {

		printf("\nBat doesn't exist\n");
  // file doesn't exist
}

//=============================================
// X11
sprintf(set_to_bar, "%s |BAT %s[%d]%%",time_buffer,bat_icon,battery_percentage);
 Display *display = XOpenDisplay(NULL);
    if (display == NULL) {
        fprintf(stderr, "Unable to open display.\n");
        return 1;
    }

    Window root = DefaultRootWindow(display);
    XStoreName(display, root, set_to_bar);

    XCloseDisplay(display);

    return 0;
}

// int battery_warning(){
// if (battery_percentage <=15) {
// system("dunstify 'Battery Warning' 'Low Battery' -u critical");
// 	}
// return 0;
// }
//=======================================

int main() {
	while(1){
	display_titlebar_x();
	//battery_warning();
	sleep(30);
	}
}
