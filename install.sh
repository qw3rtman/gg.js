install() {
    # Notify the user that the script is being downloaded
    printf "\e[33m[~] Downloading script...\e[0m\n"

    # Download the main script and its man page to a temporary location
    curl -L#o /var/tmp/gg_$$ https://raw.githubusercontent.com/qw3rtman/gg/master/bin/gg
    curl -L#o /var/tmp/gg_$$.1 https://raw.githubusercontent.com/qw3rtman/gg/master/man/gg.1

    # Notify the user that permissions are being set
    printf "\n\e[33m[~] Setting permissions...\e[0m\n"

    # Make the downloaded script executable
    chmod -v +x /var/tmp/gg_$$

    echo

    # Ask the user if they want to install the script system-wide or just for the current user
    printf "\e[33m[~] Do you want to install gg system-wide or for the current user? (s for system-wide, u for user)\e[0m\n"
    read -p "(s/u): " choice

    if [ "$choice" = "s" ]; then
        # Install system-wide
        printf "\e[33m[~] Moving to /usr/local/bin...\e[0m\n"
        sudo mv -fv /var/tmp/gg_$$ /usr/local/bin/gg
        sudo mv -fv /var/tmp/gg_$$.1 /usr/local/share/man/man1/gg.1
        gg_path="/usr/local/bin/gg"
    elif [ "$choice" = "u" ]; then
        # Install for the current user
        printf "\e[33m[~] Moving to ~/.local/bin...\e[0m\n"
        mkdir -p $HOME/.local/bin
        mv -fv /var/tmp/gg_$$ $HOME/.local/bin/gg
        mkdir -p $HOME/.local/share/man/man1
        mv -fv /var/tmp/gg_$$.1 $HOME/.local/share/man/man1/gg.1
        gg_path="$HOME/.local/bin/gg"

        # Check if ~/.local/bin is in the PATH
        if ! echo $PATH | grep -q "$HOME/.local/bin"; then
            # If not, remind the user to add it to their PATH
            printf "\n\e[31m[✘] Reminder: ~/.local/bin is not in your PATH. Please add it by running the following command:\e[0m\n"
            printf "\e[31m[✘] echo 'export PATH=\$HOME/.local/bin:\$PATH' >> ~/.bashrc && source ~/.bashrc\e[0m\n\n"
        fi
    else
        # Handle invalid choice
        printf "\e[31m[✘] Invalid choice. Exiting...\e[0m\n"
        exit 1
    fi

    echo

    # Get the installed version of the script
    version=($($gg_path -V))

    # Notify the user that the installation was successful
    printf "\e[32m[✔] Successfully installed Git Goodies v${version}\e[0m!\n"
}

# Run the install function
install
