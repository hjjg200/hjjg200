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
    echo "Usage: backup_svn.sh <repo_path> <category_name>"
    echo "E.g.: backup_svn.sh /var/lib/svn svn1"
    echo "This will copy the dump of the specified svn repository to the \$BACKUP_DEST/svn1 in the \$BACKUP_HOST or the \$BACKUP_S3_BUCKET"
    exit 1
fi

# Vars
repoDir=$1
date=`date '+%Y%m%d-%H%M%S'`
backupName=${date}_${repoDir//\//-}.svndump # All slashes replaced with hyphen
filepath="$BACKUP_PATH/tmp/$backupName"
category=$2

# Check if path is svn repo
svnadmin info $repoDir &> /dev/null || {
    echo "$repoDir is not a svn repository"
    exit 1
}

# Temp
svnadmin dump $repoDir > "$filepath"

# Backup
$BACKUPPATH/bin/backup.sh "$filepath" "$category"

# Delete
rm "$filepath"