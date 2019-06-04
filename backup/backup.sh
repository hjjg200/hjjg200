#!/bin/bash

# Check
if [[ ! "$#" -eq 2 ]]; then
    echo "Usage: backup.sh <file_path> <destination_directory>"
    echo "E.g.: backup.sh /some/file.tar.gz /backup/myfiles"
    echo "This will copy the some.tar.gz to /backup/myfiles directory in the \$BACKUPHOST"
    exit 1
fi

# Backup
filename=$1
destDir=$2

# Execute and log
cmd="scp $filename $BACKUPHOST:$destDir"
$BACKUPPATH/bin/log.sh "$cmd"
$cmd
