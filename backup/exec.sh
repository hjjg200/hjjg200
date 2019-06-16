#!/bin/bash

# Check

{ # Load config and sanity check
    . ~/.backup_config &&
    $BACKUP_PATH/bin/sanity.sh
} || {
    echo "Backup is not properly configured"
    exit 1
}

# Vars
cmd="$1"
date=`date '+%Y%m'`
timestamp=`date '+%H:%M:%S'`
logFile=$BACKUP_PATH/log/${date}.log

# Log
echo "$timestamp +$cmd" >> "$logFile"

# Execute
eval $cmd >> "$logFile" 2>&1
