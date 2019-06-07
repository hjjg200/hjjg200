#!/bin/bash

# Check

{ # Load config
    [[ ! "$BACKUPCONFIG" -eq "" ]] &&
    . "$BACKUPCONFIG"
} || . ~/.backup-config

$BACKUPPATH/bin/sanity.sh || {
    echo "Backup is not properly configured"
    exit 1
}

if [[ ! "$#" -eq 2 ]]; then
    echo "Usage: backup.sh <file_path> <destination_directory>"
    echo "E.g.: backup.sh /some/file.tar.gz /backup/myfiles"
    echo "This will copy the some.tar.gz to /backup/myfiles directory in the \$BACKUPHOST"
    exit 1
fi

# Prepare
bcs=${BACKUP_CHECKSUM,,}
if [[ "$bcs" -eq "sha1" ]]; then
    csapp=sha1sum
    csext=.sha1
elif [[ "$bcs" -eq "sha256" ]]; then
    csapp=sha256sum
    csext=.sha256
else
    caspp=md5sum
    csext=.md5
fi

# Backup
filename=$1
destDir=$2

# Checksum
$csapp $filename > $filename$csext
cmd="scp -p $filename$csext $BACKUPHOST:$destDir"
$BACKUPPATH/bin/exec.sh "$cmd"

# Execute and log
cmd="scp -p $filename $BACKUPHOST:$destDir"
$BACKUPPATH/bin/exec.sh "$cmd"
