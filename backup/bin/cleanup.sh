#!/bin/bash

# Check

{ # Load config and sanity check
    . ~/.backup_config &&
    $BACKUP_PATH/bin/sanity.sh
} || {
    echo "Backup is not properly configured"
    exit 1
}

if [[ ! "$#" -eq 3 ]]; then
    echo "Usage: cleanup.sh <category_name> <grep_pattern> <limit>"
    echo "E.g.: cleanuo.sh sometype1 .tar.gz 3"
    echo "This will remove all the files that contain .tar.gz in \$BACKUP_DEST/sometype1 in the \$BACKUP_HOST or \$BACKUP_S3_BUCKET excluding the 3 latest ones."
    exit 1
fi

# Vars
category=$1
grepPattern=$2
limit=$3

case $BACKUP_TYPE in
s3)
    # S3 paths must end with a slash
    # PRE in ls result is for prefixes
    # Print the date and name only and sort by the date
    targets=$(aws s3 ls "s3://$BACKUP_S3_BUCKET/$BACKUP_DEST/$category/" | awk '{ if ( $1 != "PRE" ) { $3=""; print $0; } }' | sort -n)
    targets=$(printf "$targets" | awk '{$1=$2=""; print $0}' | sed 's/^[ \t]*//' | grep $grepPattern)
    lineCount=$(printf "$targets" | wc -l)

    delete () {
        $BACKUP_PATH/bin/exec.sh "aws s3 rm s3://$BACKUP_S3_BUCKET/$BACKUP_DEST/$category/$1"
    }
    ;;
scp)
    # Delete
    targets=$(ssh $BACKUP_HOST "find \"${BACKUP_DEST}/${category}\" -printf \"%T@ %f\n\"" | sort -n)
    targets=$(printf "$targets" | awk '{print $2}' | grep $grepPattern)
    lineCount=$(printf "$targets" | wc -l)

    delete () {
        $BACKUP_PATH/bin/exec.sh "ssh $BACKUP_HOST 'rm $BACKUP_DEST/$category/$1'"
    }
    ;;
esac

# Check
if (( lineCount > limit )); then
    deletedCount=$(($lineCount-$limit))
    deleted=$(printf "$targets" | head -n $deletedCount)

    # Delete
    while read l; do
        delete "$l"
    done <<< "$deleted"
fi