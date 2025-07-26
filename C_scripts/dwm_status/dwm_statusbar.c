#include <stdio.h>
#include <time.h>
#include <string.h>
#include <X11/Xlib.h>
#include <unistd.h>
#include <stdlib.h>
#include <limits.h>
#include <signal.h>

// Global variables
time_t rawtime;
struct tm *timeinfo;
char time_buffer[80];
int battery_percentage;
char set_to_bar[256];
char charging_status[20] = "Unknown";
char bat_icon[100] = "[No Battery]";
int en_full_max;
int en_now_max;
int bat_number;
Display *display = NULL;  // Persistent display connection

#define POWER_SUPPLY_PATH "/sys/class/power_supply/"
#define MAX_BATTERIES 4

// Signal handler for clean exit
void handle_signal(int sig) {
    if (display) {
        XCloseDisplay(display);
        display = NULL;
    }
    exit(0);
}

int battery_functions() {
    char fileName[PATH_MAX];
    FILE *file;
    en_full_max = 0;
    en_now_max = 0;
    bat_number = -1;
    int highest_battery = -1;

    // Find highest existing battery
    for (int i = MAX_BATTERIES - 1; i >= 0; i--) {
        snprintf(fileName, sizeof(fileName), "%sBAT%d/energy_now", POWER_SUPPLY_PATH, i);
        if (access(fileName, F_OK) == 0) {
            highest_battery = i;
            break;
        }
    }

    // Process all batteries but prioritize status from highest
    for (int i = 0; i < MAX_BATTERIES; i++) {
        int en_now_local = 0;
        int en_full_local = 0;

        // Read energy_now
        snprintf(fileName, sizeof(fileName), "%sBAT%d/energy_now", POWER_SUPPLY_PATH, i);
        if (access(fileName, F_OK) != 0) continue;
        
        file = fopen(fileName, "r");
        if (file == NULL) continue;
        if (fscanf(file, "%d", &en_now_local) != 1) {
            fclose(file);
            continue;
        }
        fclose(file);

        // Read energy_full
        snprintf(fileName, sizeof(fileName), "%sBAT%d/energy_full", POWER_SUPPLY_PATH, i);
        file = fopen(fileName, "r");
        if (file == NULL) continue;
        if (fscanf(file, "%d", &en_full_local) != 1) {
            fclose(file);
            continue;
        }
        fclose(file);

        // Only add if both values were read successfully
        en_now_max += en_now_local;
        en_full_max += en_full_local;
        bat_number = i;  // Track last valid battery
    }

    // Get status from highest battery
    if (highest_battery >= 0) {
        snprintf(fileName, sizeof(fileName), "%sBAT%d/status", POWER_SUPPLY_PATH, highest_battery);
        file = fopen(fileName, "r");
        if (file != NULL) {
            if (fscanf(file, "%19s", charging_status) != 1) {
                strcpy(charging_status, "Unknown");
            }
            fclose(file);
        } else {
            strcpy(charging_status, "Unknown");
        }
    }

    if (en_full_max == 0) {
        strcpy(bat_icon, "[No Battery]");
        battery_percentage = 0;
        return 0;
    }

    // Convert to same scale (preserve trailing zeros handling)
    en_now_max /= 1000;
    en_full_max /= 1000;
    battery_percentage = (en_now_max * 100 + en_full_max / 2) / en_full_max;

    // Clamp percentage
    if (battery_percentage > 100) battery_percentage = 100;
    if (battery_percentage < 0) battery_percentage = 0;

    // Battery icon construction with bounds checking
    static const char *BAT_ARRAY[] = {"🟥","🟥","🟧","🟧","🟨","🟨","🟩","🟩","🟦","🟦"};
    char temp_icon[100] = "[";
    size_t current_len = 1;  // Starts with '['
    size_t max_len = sizeof(temp_icon) - 1;

    int bat_10 = (battery_percentage + 5) / 10;
    if (bat_10 > 10) bat_10 = 10;
    if (bat_10 < 0) bat_10 = 0;

    // Add filled blocks
    for (int i = 0; i < bat_10; i++) {
        const char *block = BAT_ARRAY[i];
        size_t block_len = strlen(block);
        
        if (current_len + block_len > max_len) break;
        strncat(temp_icon, block, max_len - current_len);
        current_len += block_len;
    }

    // Add empty blocks
    const char *empty_block = "⬛";
    size_t empty_len = strlen(empty_block);
    for (int i = bat_10; i < 10; i++) {
        if (current_len + empty_len > max_len) break;
        strncat(temp_icon, empty_block, max_len - current_len);
        current_len += empty_len;
    }

    // Add status icon
    const char *status_icon = (strcmp(charging_status, "Charging") == 0) ? "⚡" : "⏬";
    size_t status_len = strlen(status_icon);
    
    if (current_len + 1 + status_len <= max_len) {  // +1 for ']'
        strncat(temp_icon, "]", max_len - current_len);
        strncat(temp_icon, status_icon, max_len - current_len - 1);
    }

    strncpy(bat_icon, temp_icon, sizeof(bat_icon));
    bat_icon[sizeof(bat_icon)-1] = '\0';
    return 0;
}

int update_titlebar() {
    // Time
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    strftime(time_buffer, sizeof(time_buffer), "%a %d %b %I:%M %p", timeinfo);

    // Update battery status
    battery_functions();

    // Build status string
    snprintf(set_to_bar, sizeof(set_to_bar), 
             "%s |BAT %s[%d]%%", time_buffer, bat_icon, battery_percentage);

    // Update X11 root window
    if (!display) {
        display = XOpenDisplay(NULL);
        if (!display) return 1;
    }

    Window root = DefaultRootWindow(display);
    XStoreName(display, root, set_to_bar);
    XFlush(display);
    return 0;
}

int main() {
    // Set up signal handler for clean exit
    signal(SIGINT, handle_signal);
    signal(SIGTERM, handle_signal);

    while(1) {
        if (update_titlebar()) {
            // Recover from display errors
            if (display) XCloseDisplay(display);
            display = NULL;
        }
        sleep(30);
    }
}
