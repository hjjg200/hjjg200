
# Check
if [[ ! "$#" -eq 3 ]]; then
    echo "Wrong argument count"
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
    p=$1
    cmd="rm $1"
    $BACKUPPATH/bin/log.sh "$cmd"
    $cmd
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
