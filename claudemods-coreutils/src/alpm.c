#include "config.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>   // For isalnum()
#include <stdbool.h> // For bool

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: alpm <package_name>\n");
        return EXIT_FAILURE;
    }

    const char *package_name = argv[1];

    // Validate package name to prevent command injection
    for (size_t i = 0; package_name[i] != '\0'; i++) {
        if (!isalnum(package_name[i]) && package_name[i] != '-' && package_name[i] != '_') {
            fprintf(stderr, "Error: Invalid package name '%s'. Only alphanumeric characters, '-', and '_' are allowed.\n", package_name);
            return EXIT_FAILURE;
        }
    }

    char command[1024];

    // Step 1: Clone the AUR package repository
    snprintf(command, sizeof(command), "git clone https://aur.archlinux.org/%s.git /tmp/%s", package_name, package_name);
    printf("Cloning AUR package %s...\n", package_name);
    if (system(command) != 0) {
        fprintf(stderr, "Error: Failed to clone AUR package %s.\n", package_name);
        return EXIT_FAILURE;
    }

    // Step 2: Build the package using makepkg
    snprintf(command, sizeof(command), "cd /tmp/%s && makepkg -si --noconfirm", package_name);
    printf("Building and installing %s...\n", package_name);
    if (system(command) != 0) {
        fprintf(stderr, "Error: Failed to build or install %s.\n", package_name);

        // Clean up on failure
        snprintf(command, sizeof(command), "rm -rf /tmp/%s", package_name);
        printf("Cleaning up...\n");
        if (system(command) != 0) {
            fprintf(stderr, "Warning: Cleanup failed for %s.\n", package_name);
        }

        return EXIT_FAILURE;
    }

    // Step 3: Clean up
    snprintf(command, sizeof(command), "rm -rf /tmp/%s", package_name);
    printf("Cleaning up...\n");
    if (system(command) != 0) {
        fprintf(stderr, "Warning: Cleanup failed for %s.\n", package_name);
    }

    printf("Package %s installed successfully.\n", package_name);
    return EXIT_SUCCESS;
}
