#!/bin/bash

# Check

{ # Load config
    [[ ! "$BACKUPCONFIG" -eq "" ]] &&
    . "$BACKUPCONFIG"
} || . ~/.backup-config

$BACKUPPATH/bin/sanity.sh || {
    echo "Backup is not properly configured"
    exit 1
}

# Vars
cmd="$1"
date=`date '+%Y%m'`
timestamp=`date '+%Y-%m-%d %H:%M:%S'`
logFile=$BACKUPPATH/log/${date}.log

# Log
echo "$timestamp > +$cmd" >> "$logFile"

# Execute
$cmd >> "$logFile" 2>&1