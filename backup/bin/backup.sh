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
    echo "Usage: backup.sh <file_path> <category_name>"
    echo "E.g.: backup.sh /some/file.tar.gz myfiles"
    echo "This will copy the some.tar.gz to \$BACKUP_DEST/files directory in the \$BACKUP_HOST or the \$BACKUP_S3_BUCKET"
    exit 1
fi

# Checksum
csapp=sha1sum
csext=.sha1

# Backup
filepath=$1
category=$2
destDir="$BACKUP_DEST/$category"

# Checksum
bn=`basename $filepath`
cs=`$csapp $filepath`

# Backup
case $BACKUP_TYPE in
s3)
    # Copy checksum
    $BACKUP_PATH/bin/exec.sh "printf $cs | aws s3 cp - s3://$BACKUP_S3_BUCKET/$destDir/$bn$csext"

    # Copy file
    $BACKUP_PATH/bin/exec.sh "aws s3 cp $filepath s3://$BACKUP_S3_BUCKET/$destDir/$bn --storage-class GLACIER"
    ;;
scp)
    # Copy checksum
    $BACKUP_PATH/bin/exec.sh "printf $cs | ssh $BACKUP_HOST 'cat > $destDir/$bn$csext'"

    # Copy file
    $BACKUP_PATH/bin/exec.sh "scp -p $filepath $BACKUP_HOST:$destDir/$bn"
    ;;
esac

