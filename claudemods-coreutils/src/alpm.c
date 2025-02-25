
#include <config.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>   // For isalnum()
#include <stdbool.h> // For bool
#include <unistd.h>  // For getenv()
#include <sys/stat.h> // For mkdir()

// Function to execute a shell command and capture its output
char *execute_command(const char *command) {
    FILE *fp = popen(command, "r");
    if (fp == NULL) {
        perror("Failed to execute command");
        return NULL;
    }

    static char output[1024];
    if (fgets(output, sizeof(output), fp)) {
        pclose(fp);
        return output;
    }

    pclose(fp);
    return NULL;
}

// Function to extract the version from a PKGBUILD
char *get_pkgbuild_version(const char *package_name) {
    char command[1024];
    snprintf(command, sizeof(command), "git clone https://aur.archlinux.org/%s.git /tmp/%s && cd /tmp/%s && source PKGBUILD && echo $pkgver", package_name, package_name, package_name);

    // Debugging: Print the command to verify it's correct
    printf("Executing command: %s\n", command);

    // Execute the command
    char *output = execute_command(command);
    if (output == NULL) {
        fprintf(stderr, "Error: Failed to fetch PKGBUILD for %s.\n", package_name);
        return NULL;
    }

    // Remove trailing newline (if any)
    output[strcspn(output, "\n")] = '\0';
    return output;
}

// Function to compare two version strings
int compare_versions(const char *v1, const char *v2) {
    return strverscmp(v1, v2);
}

// Function to create the config directory and file if they don't exist
void ensure_config_file_exists() {
    const char *home_dir = getenv("HOME");
    if (home_dir == NULL) {
        perror("Failed to get HOME directory");
        exit(EXIT_FAILURE);
    }

    char config_dir[256];
    snprintf(config_dir, sizeof(config_dir), "%s/.config/apextools", home_dir);

    // Create the directory if it doesn't exist
    if (mkdir(config_dir, 0755) != 0 && errno != EEXIST) {
        perror("Failed to create config directory");
        exit(EXIT_FAILURE);
    }

    char config_file[256];
    snprintf(config_file, sizeof(config_file), "%s/localpackagesaur.txt", config_dir);

    // Create the file if it doesn't exist
    FILE *file = fopen(config_file, "a");
    if (file == NULL) {
        perror("Failed to create config file");
        exit(EXIT_FAILURE);
    }
    fclose(file);
}

// Function to write a package and its version to the config file
void write_package_version(const char *package_name, const char *version) {
    const char *home_dir = getenv("HOME");
    if (home_dir == NULL) {
        perror("Failed to get HOME directory");
        return;
    }

    char config_file[256];
    snprintf(config_file, sizeof(config_file), "%s/.config/apextools/localpackagesaur.txt", home_dir);

    FILE *file = fopen(config_file, "a");
    if (file == NULL) {
        perror("Failed to open config file");
        return;
    }

    fprintf(file, "%s=%s\n", package_name, version);
    fclose(file);
}

// Function to read the package versions from the config file
char *read_package_version(const char *package_name) {
    const char *home_dir = getenv("HOME");
    if (home_dir == NULL) {
        perror("Failed to get HOME directory");
        return NULL;
    }

    char config_file[256];
    snprintf(config_file, sizeof(config_file), "%s/.config/apextools/localpackagesaur.txt", home_dir);

    FILE *file = fopen(config_file, "r");
    if (file == NULL) {
        perror("Failed to open config file");
        return NULL;
    }

    static char line[256];
    while (fgets(line, sizeof(line), file)) {
        char name[128];
        char version[128];
        if (sscanf(line, "%[^=]=%s", name, version) == 2 && strcmp(name, package_name) == 0) {
            fclose(file);
            return strdup(version);
        }
    }

    fclose(file);
    return NULL;
}

// Function to handle the 'update aur' command
void update_aur_packages() {
    printf("Checking for AUR package updates...\n");

    const char *home_dir = getenv("HOME");
    if (home_dir == NULL) {
        perror("Failed to get HOME directory");
        return;
    }

    char config_file[256];
    snprintf(config_file, sizeof(config_file), "%s/.config/apextools/localpackagesaur.txt", home_dir);

    FILE *file = fopen(config_file, "r");
    if (file == NULL) {
        perror("Failed to open config file");
        return;
    }

    char line[256];
    while (fgets(line, sizeof(line), file)) {
        char package_name[128];
        char local_version[128];
        if (sscanf(line, "%[^=]=%s", package_name, local_version) == 2) {
            // Get the latest version from the PKGBUILD
            char *aur_version = get_pkgbuild_version(package_name);
            if (aur_version == NULL) {
                fprintf(stderr, "Error: Failed to fetch PKGBUILD for %s.\n", package_name);
                continue;
            }

            // Print current and online versions in gold
            printf("\033[93mCurrent version of %s: %s\033[0m\n", package_name, local_version);
            printf("\033[93mOnline version of %s: %s\033[0m\n", package_name, aur_version);

            // Compare versions
            if (compare_versions(local_version, aur_version) < 0) {
                printf("Update available for %s: %s -> %s\n", package_name, local_version, aur_version);

                // Install the updated package
                char system_command[1024];
                snprintf(system_command, sizeof(system_command), "cd /tmp/%s && makepkg -si --noconfirm && rm -rf /tmp/%s", package_name, package_name);

                // Debugging: Print the command to verify it's correct
                printf("Executing command: %s\n", system_command);

                if (system(system_command) != 0) {
                    fprintf(stderr, "Error: Failed to update %s.\n", package_name);
                } else {
                    printf("Successfully updated %s to version %s.\n", package_name, aur_version);
                    // Update the version in the config file
                    write_package_version(package_name, aur_version);
                }
            } else {
                printf("%s is up to date (%s).\n", package_name, local_version);
            }

            // Clean up the cloned repository
            char cleanup_command[256];
            snprintf(cleanup_command, sizeof(cleanup_command), "rm -rf /tmp/%s", package_name);
            system(cleanup_command);
        }
    }

    fclose(file);
}

// Function to handle the 'update' command (system updates)
void update_system() {
    printf("Checking for system updates...\n");

    // Use ./apexupdater.bin for system updates
    char system_command[1024];
    snprintf(system_command, sizeof(system_command), "./apexupdater.bin update");

    // Debugging: Print the command to verify it's correct
    printf("Executing command: %s\n", system_command);

    if (system(system_command) != 0) {
        fprintf(stderr, "Error: Failed to update system.\n");
    } else {
        printf("System updated successfully.\n");
    }
}

int main(int argc, char *argv[]) {
    // Print the header in bright teal
    printf("\033[96m"); // Set color to bright teal
    printf("Apex Linux Package Manager System v1.0 Build 25-02-2025\n");
    printf("\033[0m"); // Reset color to default

    // Ensure the config file exists
    ensure_config_file_exists();

    if (argc < 2) {
        // Print the usage and commands in gold
        printf("\033[93m"); // Set color to gold
        printf("Usage: alpm <command> [args]\n");
        printf("Commands:\n");
        printf("  reboot            - Reboot the system\n");
        printf("  shutdown          - Shutdown the system\n");
        printf("  makeiso           - Create ISO using a script\n");
        printf("  makeisogui        - Create ISO using a GUI script\n");
        printf("  installscript     - Run installation script\n");
        printf("  installer         - Run installation GUI\n");
        printf("  update            - Check and update system packages\n");
        printf("  update aur        - Check and update AUR packages\n");
        printf("  browser           - Launch browser\n");
        printf("  install <package> - Install an AUR package\n");
        printf("\033[0m"); // Reset color to default
        return EXIT_FAILURE;
    }

    const char *command = argv[1];

    if (strcmp(command, "reboot") == 0) {
        // Reboot the system
        char system_command[1024];
        snprintf(system_command, sizeof(system_command), "/usr/local/bin/reboot.sh");
        system(system_command);
    } else if (strcmp(command, "shutdown") == 0) {
        // Shutdown the system
        char system_command[1024];
        snprintf(system_command, sizeof(system_command), "/usr/local/bin/shutdown.sh");
        system(system_command);
    } else if (strcmp(command, "makeiso") == 0) {
        // Create ISO using a script
        char system_command[1024];
        snprintf(system_command, sizeof(system_command), "./apexisocreatorscript.bin");
        system(system_command);
    } else if (strcmp(command, "makeisogui") == 0) {
        // Create ISO using a GUI script
        char system_command[1024];
        snprintf(system_command, sizeof(system_command), "./apexisocreatorgui.bin");
        system(system_command);
    } else if (strcmp(command, "installscript") == 0) {
        // Run installation script
        char system_command[1024];
        snprintf(system_command, sizeof(system_command), "./apexinstallerescript");
        system(system_command);
    } else if (strcmp(command, "installer") == 0) {
        // Run installation GUI
        char system_command[1024];
        snprintf(system_command, sizeof(system_command), "./apexinstallgui.bin");
        system(system_command);
    } else if (strcmp(command, "update") == 0) {
        if (argc > 2 && strcmp(argv[2], "aur") == 0) {
            // Update AUR packages
            char system_command[1024];
            snprintf(system_command, sizeof(system_command), "./apexupdater.bin update aur");
            system(system_command);
        } else {
            // Update system packages
            update_system();
        }
    } else if (strcmp(command, "browser") == 0) {
        // Launch browser
        char system_command[1024];
        snprintf(system_command, sizeof(system_command), "./apexbrowser");
        system(system_command);
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

        // Use ./installpackage.bin to install the package
        char system_command[1024];
        snprintf(system_command, sizeof(system_command), "./installpackage.bin %s", package_name);

        // Debugging: Print the command to verify it's correct
        printf("Executing command: %s\n", system_command);

        if (system(system_command) != 0) {
            fprintf(stderr, "Error: Failed to install %s.\n", package_name);
            return EXIT_FAILURE;
        }

        // Get and print the installed version
        char *aur_version = get_pkgbuild_version(package_name);
        if (aur_version != NULL) {
            printf("Successfully installed %s version %s.\n", package_name, aur_version);
            // Write the package and version to the config file
            write_package_version(package_name, aur_version);
        } else {
            fprintf(stderr, "Warning: Failed to get AUR version for %s.\n", package_name);
        }
    } else {
        fprintf(stderr, "Error: Unknown command '%s'.\n", command);
        return EXIT_FAILURE;
    }

    printf("Command '%s' executed successfully.\n", command);
    return EXIT_SUCCESS;
}
