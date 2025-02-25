#include <config.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>   // For isalnum()
#include <stdbool.h> // For bool

int main(int argc, char *argv[]) {
    // Print the header in bright teal
    printf("\033[96m"); // Set color to bright teal
    printf("Apex Linux Package Manager System v1.0 Build 25-02-2025\n");
    printf("\033[0m"); // Reset color to default

    if (argc < 2) {
        // Print the usage and commands in gold
        printf("\033[93m"); // Set color to gold
        printf("Usage: alpm <command> [args]\n");
        printf("Commands:\n");
        printf("  reboot            - Reboot the system\n");
        printf("  shutdown          - Shutdown the system\n");
        printf("  repo list         - List repositories\n");
        printf("  makeiso           - Create ISO using a script\n");
        printf("  makeisogui        - Create ISO using a GUI script\n");
        printf("  installscript     - Run installation script\n");
        printf("  installer         - Run installation GUI\n");
        printf("  update            - Run system updater\n");
        printf("  browser           - Launch browser\n");
        printf("  install <package> - Install an AUR package\n");
        printf("\033[0m"); // Reset color to default
        return EXIT_FAILURE;
    }

    const char *command = argv[1];
    char system_command[1024];

    if (strcmp(command, "reboot") == 0) {
        // Reboot the system
        snprintf(system_command, sizeof(system_command), "/usr/local/bin/reboot.sh");
    } else if (strcmp(command, "shutdown") == 0) {
        // Shutdown the system
        snprintf(system_command, sizeof(system_command), "/usr/local/bin/shutdown.sh");
    } else if (strcmp(command, "repo") == 0 && argc > 2 && strcmp(argv[2], "list") == 0) {
        // List repositories
        snprintf(system_command, sizeof(system_command), "/usr/local/bin/repolist.sh");
    } else if (strcmp(command, "makeiso") == 0) {
        // Create ISO using a script
        snprintf(system_command, sizeof(system_command), "./apexisocreatorscript.bin");
    } else if (strcmp(command, "makeisogui") == 0) {
        // Create ISO using a GUI script
        snprintf(system_command, sizeof(system_command), "./apexisocreatorgui.bin");
    } else if (strcmp(command, "installscript") == 0) {
        // Run installation script
        snprintf(system_command, sizeof(system_command), "./apexinstallerescript");
    } else if (strcmp(command, "installer") == 0) {
        // Run installation GUI
        snprintf(system_command, sizeof(system_command), "./apexinstallgui.bin");
    } else if (strcmp(command, "update") == 0) {
        // Run system updater
        snprintf(system_command, sizeof(system_command), "./apexupdater.bin");
    } else if (strcmp(command, "browser") == 0) {
        // Launch browser
        snprintf(system_command, sizeof(system_command), "./apexbrowser");
    } else if (strcmp(command, "install") == 0 && argc > 2) {
        // Install an AUR package
        const char *package_name = argv[2];

        // Validate package name
        for (size_t i = 0; package_name[i] != '\0'; i++) {
            if (!isalnum(package_name[i]) && package_name[i] != '-' && package_name[i] != '_') {
                fprintf(stderr, "Error: Invalid package name '%s'. Only alphanumeric characters, '-', and '_' are allowed.\n", package_name);
                return EXIT_FAILURE;
            }
        }

        // Clone, build, and install the package
        snprintf(system_command, sizeof(system_command), "git clone https://aur.archlinux.org/%s.git /tmp/%s && cd /tmp/%s && makepkg -si --noconfirm && rm -rf /tmp/%s", package_name, package_name, package_name, package_name);
    } else {
        fprintf(stderr, "Error: Unknown command '%s'.\n", command);
        return EXIT_FAILURE;
    }

    // Execute the command
    if (system(system_command) != 0) {
        fprintf(stderr, "Error: Failed to execute command '%s'.\n", command);
        return EXIT_FAILURE;
    }

    printf("Command '%s' executed successfully.\n", command);
    return EXIT_SUCCESS;
}
