#!/bin/bash

# Check

{ # Load config
    [[ ! "$BACKUPCONFIG" -eq "" ]] &&
    . "$BACKUPCONFIG"
} || . ~/.backup-config

$BACKUPPATH/sanity.sh || {
    echo "Backup is not properly configured"
    exit 1
}

if [[ ! "$#" -eq 2 ]]; then
    echo "Usage: backup_svn.sh <repo_path> <category_name>"
    echo "E.g.: backup_svn.sh /var/lib/svn svn1"
    echo "This will copy the dump of the specified svn repository to the \$BACKUPDEST/svn1 in the \$BACKUPHOST"
    exit 1
fi

# Vars
repoDir=$1
date=`date '+%Y%m%d'`
backupName=${date}.svndump
destDir=$BACKUPDEST/$2

# Check if path is svn repo
svnadmin info $repoDir &> /dev/null
if [[ ! "$?" -eq 0 ]]; then
    echo "$repoDir is not a svn repository"
    exit 1
fi

# Dump and copy
cmd="svnadmin dump $repoDir | ssh $BACKUPHOST 'cat > $destDir/$backupName'"
$BACKUPPATH/bin/log.sh "$cmd"
$cmd
