#1/bin/bash

# Check

$BACKUPPATH/bin/sanity.sh || {
    echo "Backup is not properly configured"
    exit 1
}

if [[ ! "$#" -eq 3 ]]; then
    echo "Usage: backup_latest.sh <target_directory> <grep_pattern> <category_name>"
    echo "E.g.: backup_latest.sh /path/to/backup .txt document"
    echo "This will copy the latest file that contains .txt in /path/to/backup to \$BACKUPDEST/document folder in the \$BACKUPHOST"
    exit 1
fi

# Vars
backupDir=$1
grepPattern=$2
destDir=$BACKUPDEST/$3

# Fetch the list of backup files sorted by modified time
backups=$(find $backupDir -type f -printf "%T@ %f\n" | sort -n | awk '{print $2}')
backups=$(echo "$backups" | grep $grepPattern)

# Get the latest backup
latest=$backupDir/$(echo "$backups" | tail -n 1)

# Move
echo "Moving the latest backup: $latest"
$BACKUPPATH/bin/backup.sh $latest $destDir
