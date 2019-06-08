#!/bin/bash

# Check

$BACKUPPATH/bin/sanity.sh || {
    echo "Backup is not properly configured"
    exit 1
}

if [[ ! "$#" -eq 3 ]]; then
    echo "Usage: cleanup.sh <target_directory> <grep_pattern> <limit>"
    echo "E.g.: cleanuo.sh /some/folder .tar.gz 3"
    echo "This will remove all the files that contain .tar.gz in /some/folder excluding the 3 latest ones."
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
    cmd="rm $1"
    $BACKUPPATH/bin/exec.sh "$cmd"
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
