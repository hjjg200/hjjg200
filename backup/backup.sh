#!/bin/bash

# Functions
elementBelongs () {
    local e=$1
    shift
    for i; do
        [[ "$i" -eq "$e" ]] && return 0
    done
    return 1
}

# Check
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
csstr=`$csapp $filename`
cmd="scp $filename$csext $BACKUPHOST:$destDir"
$BACKUPPATH/bin/log.sh "$cmd"
$cmd

# Execute and log
cmd="scp $filename $BACKUPHOST:$destDir"
$BACKUPPATH/bin/log.sh "$cmd"
$cmd
