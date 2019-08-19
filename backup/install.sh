#!/bin/bash

# Vars
gitrepo="https://github.com/hjjg200/hjjg200"
bindir="/backup/bin" # Path to backup bin dir in the repo

# Check interactive mode
{
    [[ $- == *i* ]] && # Interactive shell has i option set
    [[ ! "$PS1" == "" ]] # Interactive shell has $PS1 set
} || {
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
    mkdir $backuppath/cfg &&
    mkdir $backuppath/log &&
    mkdir $backuppath/tmp &&
    cleanupcmds+=("rm -r $backuppath")
} || { # Catch
    echo "Setting $backuppath as the root backup directory failed"
    echo "Please double-check your settings"
    cleanup
    exit 1
}

while [[ ! $backuptype =~ s3|scp ]]; do {
    read -p "Backup type (s3, scp): " backuptype
} done

case $backuptype in
s3)
    read -p "AWS access key: " awsAccessKey
    read -p "AWS secret token: " awsSecretToken
    read -p "S3 bucket name: " s3BucketName
    awsCredentials="$backuppath/cfg/aws_credentials"
    { # credentials
        # AWS_SHARED_CREDENTIALS_FILE
        echo "[default]"
        echo "aws_access_key_id=$awsAccessKey"
        echo "aws_secret_access_key=$awsSecretToken"
    } > "$awsCredentials"
    echo "AWS crednetials file is stored at $awsCredentials with 400 perms"

    # Set perms
    chmod 400 "$awsCredentials"
    export AWS_SHARED_CREDENTIALS_FILE="$awsCredentials"

    #
    read -p "S3 prefix for backups: " backupdest
    # Remove trailing slash
    backupdest=`echo $backupdest | sed 's/\/$//'`

    # Check s3 access
    { # Try
        aws s3 ls "s3://$s3BucketName" &> /dev/null &&
        awsTestTmpFile=s3://${s3BucketName}/${backupdest}/glacier_test.tmp &&
        printf 'glacier_test' | aws s3 cp - $awsTestTmpFile &&
        aws s3 rm $awsTestTmpFile
    } || { # Catch
        echo "Failed to properly access the s3 bucket"
        echo "Read and write permissions for the bucket are needed"
        echo "And the awscli must support GLACIER storage class"
        cleanup
        exit 1
    }

    ;;
scp)
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
    ;;
esac

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
    echo "BACKUP_PATH=$backuppath"
    echo "BACKUP_TYPE=$backuptype"
    echo "BACKUP_DEST=$backupdest"
    case $backuptype in
    s3)
        echo "export AWS_SHARED_CREDENTIALS_FILE=$awsCredentials"
        echo "BACKUP_S3_BUCKET=$s3BucketName"
        ;;
    scp)
        echo "BACKUP_HOST=$backuphost"
        ;;
    esac
} > "$cfg" || {
    echo "Failed to write to $cfg"
    cleanup
    exit 1
}

# Complete
echo "Installation complete!"
