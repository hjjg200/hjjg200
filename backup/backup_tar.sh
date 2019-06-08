#!/bin/bash

# Check

$BACKUPPATH/bin/sanity.sh || {
    echo "Backup is not properly configured"
    exit 1
}

if [[ ! "$#" -eq 2 ]]; then
    echo "Usage: backup_tar.sh <path_pattern> <category_name>"
    echo "E.g.: backup_tar.sh /var/some/folder category1"
    echo "This will compress the folder as .tar.gz and send it to \$BACKUPDEST/category1 in \$BACKUPHOST"
    exit 1
fi

# Vars
targetDir=$1
destDir=$BACKUPDEST/$2
backupName=`date '+%Y%m%d_%H%M%S'`_${2}_backup.tar.gz
tmpName=/tmp/$backupName

# Compress
tar czvf $tmpName $targetDir

# Send compressed file
$BACKUPPATH/bin/backup.sh $tmpName $destDir

# Remove the temp file
rm $tmpName