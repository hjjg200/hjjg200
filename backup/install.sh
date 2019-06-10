#!/bin/bash

# Vars
gitrepo="https://github.com/hjjg200/hjjg200"
bindir="/backup" # Path to backup bin dir in the repo

# Check interactive mode
[[ $- == *i* ]] || {
    echo "This script must be run in the interactive mode"
    echo "Run this script like bash -i <(curl -s <url_to_script>)"
    exit 1
}

# Cleaning commands
declare -a cleanupcmds
cleanup () { # Cleaning up upon failure
    for i in "${cleanupcmds[@]}"; do
        eval "$i"
    done
}

# Settings
read -p "Root directory for backup settings: " backuppath

{ # Try
    backuppath=${backuppath/#~/$HOME} && # Replace tildes
    [ ! "$backuppath" == "" ] &&
    mkdir -p $backuppath &&
    backuppath=`realpath $backuppath` &&
    # mkdir $backuppath/bin && bin will be symlink
    mkdir $backuppath/log &&
    mkdir $backuppath/tmp &&
    cleanupcmds+=("rm -r $backuppath")
} || { # Catch
    echo "Setting $backuppath as the root backup directory failed"
    echo "Please double-check your settings"
    cleanup
    exit 1
}

read -p "Backup host (username@hostname): " backuphost

{ # Try
    ssh $backuphost 'echo' 2&>1 > /dev/null
} || { # Catch
    echo "Failed to connect to the host machine"
    echo "All-time connection must be guaranteed for proper backing up"
    cleanup
    exit 1
}

read -p "Backup destination folder in the backup host: " backupdest

{ # Try
    # Check if it is a directory and the user is the owner
    ssh $backuphost "[[ -d $backupdest ]] && [[ -O $backupdest ]]"
} || { # Catch
    echo "The $backupdest directory in the backup machine cannot be accessed"
    echo "Please double-check your settings"
    cleanup
    exit 1
}

# Clone

{ # Try
    gitclonedir=$backuppath/git
    git clone $gitrepo $gitclonedir &&
    absclonedir=`realpath $gitclonedir` &&
    ln -s $absclonedir$bindir $backuppath/bin # Make symlink to the backup bin dir
} || { # Catch
    echo "Could not clone the repo and make symlink to $backuppath/bin"
    cleanup
    exit 1
}

# Environment variables

# Ensure the config folder
cfg="$HOME/.backup_config"
[[ -f "$cfg" ]] && {
    echo "The ~/.backup_config file already exists!"
    read -p "Would you like to overwrite and continue the installation? (y/N): " yn
    if [[ ! "$yn" =~ [yY] ]]; then
        echo "Installation aborted."
        cleanup
        exit 1
    fi
}

# Write the config file
{
    echo "BACKUPPATH=$backuppath"
    echo "BACKUPHOST=$backuphost"
    echo "BACKUPDEST=$backupdest"
} > "$cfg"

# Complete
echo "Installation complete!"
