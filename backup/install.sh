#!/bin/bash

gitrepo="https://github.com/hjjg200/hjjg200"
clonedir=repodir
bindir="/backup/bin"

# Cleaning commands
declare -a cleanupcmds
cleanup () { # Cleaning up upon failure
    for i in "${cleanupcmds[@]}"; do
        $i
    done
}

# Settings
read -p "Root directory for backup settings: " backuppath
{ # Try
    [ ! "$backuppath" -eq "" ] &&
    mkdir -p $backuppath &&
    # mkdir -p $backuppath/bin && bin will be symlink
    mkdir -p $backuppath/log &&
    mkdir -p $backuppath/tmp &&
    cleanupcmds+=("rm -r $backuppath")
} || { # Catch
    echo "Setting $backuppath as the root backup directory failed"
    echo "Please double-check your settings"
    cleanup
    exit 1
}

read -p "Backup host (username@hostname): " backuphost
{ # Try
    ssh $backuphost 'echo'
} || { # Catch
    echo "Failed to connect to the host machine"
    echo "All-time connection must be guaranteed for proper backing up"
    cleanup
    exit 1
}

read -p "Backup destination folder in the backup host: " backupdest
{ # Try
    ssh $backuphost "[[ -d $backupdest ]] && [[ -O $backupdest ]]"
} || { # Catch
    echo "The $backupdest directory in the backup machine cannot be accessed"
    echo "Please double-check your settings"
    cleanup
    exit 1
}

# Clone

{ # Try
    absbindir=`realpath $clonedir$bindir` &&
    git clone $gitrepo $clonedir &&
    ln -s $absbindir $backuppath/bin
} || { # Catch
    echo "Could not clone the repo and make symlink to $backuppath/bin"
    cleanup
    exit 1
}

# Environment variables

{
    echo # New line
    echo "export \$BACKUPPATH=$backuppath"
    echo "export \$BACKUPHOST=$backuphost"
    echo "export \$BACKUPDEST=$backupdest"
} >> ~/.profile

# Complete
echo "Installation complete!"