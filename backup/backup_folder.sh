#!/bin/bash

if [[ "$#" -eq 1 ]]; then
    echo "Usage: backup_folder.sh <path_to_folder> <category_name>"
    echo "E.g.: backup_folder.sh /var/some/folder category1"
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

# Hash
md5hash=$(md5sum $tmpName)

# Send Hash first
printf $md5hash | ssh $BACKUPHOST "cat > $destDir/$backupName.md5"

# Send compressed file
$BACKUPPATH/bin/backup.sh $tmpName $destDir

# Remove the temp file
rm $tmpName