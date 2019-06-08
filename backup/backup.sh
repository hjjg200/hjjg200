#!/bin/bash

# Check

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
# bcs=${BACKUP_CHECKSUM,,}
# if [[ "$bcs" -eq "sha1" ]]; then
#    csapp=sha1sum
#    csext=.sha1
#elif [[ "$bcs" -eq "sha256" ]]; then
#    csapp=sha256sum
#    csext=.sha256
#else
#    caspp=md5sum
#    csext=.md5
#fi
csapp=sha1sum
csext=.sha1

# Backup
filepath=$1
destDir=$2

# Checksum
bn=`basename $filepath`
cs=(`$csapp $filepath`)
cmd="echo $cs | ssh $BACKUPHOST 'cat > $destDir/$bn$csext'"
$BACKUPPATH/bin/exec.sh "$cmd"

# Execute and log
cmd="scp -p $filepath $BACKUPHOST:$destDir"
$BACKUPPATH/bin/exec.sh "$cmd"
