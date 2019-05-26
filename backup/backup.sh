# Check
if [[ ! "$#" -eq 2 ]]; then
    echo "Wrong argument count"
    exit 1
fi

# Backup
filename=$1
destDir=$2

# Execute and log
cmd="scp $filename $BACKUPHOST:$destDir"
$BACKUPPATH/bin/log.sh "$cmd"
$cmd
