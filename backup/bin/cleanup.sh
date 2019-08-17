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
    echo "Usage: cleanup.sh <target_directory> <grep_pattern> <limit>"
    echo "E.g.: cleanuo.sh /some/folder .tar.gz 3"
    echo "This will remove all the files that contain .tar.gz in /some/folder excluding the 3 latest ones."
    exit 1
fi

if [[ $BACKUP_TYPE == s3 ]]; then
    echo "This script is not yet supported for s3 destination"
    exit 1
fi

# Vars
targetDir=$1
grepPattern=$2
limit=$3

# Delete
targets=$(find $targetDir -printf "%T@ %f\n" | sort -n)
targets=$(echo "$targets" | awk '{print $2}' | grep $grepPattern)
lineCount=$(echo "$targets" | wc -l)

delete () {
    $BACKUP_PATH/bin/exec.sh "rm $1"
}

# Check
if (( lineCount > limit )); then
    deletedCount=$(($lineCount-$limit))
    deleted=$(echo "$targets" | head -n $deletedCount | awk '{print "'$targetDir/'"$0}')

    # Delete
    while read l; do
        delete "$l"
    done <<< "$deleted"
fi
