#!/bin/bash

# Check

{ # Load config and sanity check
    . ~/.backup_config &&
    $BACKUP_PATH/bin/sanity.sh
} || {
    echo "Backup is not properly configured"
    exit 1
}

if [[ ! "$#" -eq 2 ]]; then
    echo "Usage: backup_tar.sh <path_pattern> <category_name>"
    echo "E.g.: backup_tar.sh /var/some/folder category1"
    echo "This will compress the folder as .tar.gz and send it to \$BACKUP_DEST/category1 in \$BACKUP_HOST"
    exit 1
fi

# Vars
pathPattern=$1
destDir=$BACKUP_DEST/$2
backupName=`date '+%Y%m%d_%H%M%S'`_${2}_backup.tar.gz
tmpName=$BACKUP_PATH/tmp/$backupName

# Compress
$BACKUP_PATH/bin/exec.sh "tar czvf $tmpName $pathPattern"

# Send compressed file
$BACKUP_PATH/bin/backup.sh $tmpName $destDir

# Remove the temp file
$BACKUP_PATH/bin/exec.sh "rm $tmpName"
