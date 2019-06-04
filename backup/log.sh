#!/bin/bash

# Check
if [[ ! "$#" -eq 1 ]]; then
    echo "Usage: log.sh <command>"
    echo "E.g.: log.sh 'rm /some/deleted_file'"
    echo "This will log the command with timestamp in the log file"
    echo "The log file is located in \$BACKUPPATH/log directory"
    exit 1
fi

# Vars
cmd=$1
date=`date '+%Y%m'`
timestamp=`date '+%Y-%m-%d %H:%M:%S'`
logFile=$BACKUPPATH/log/${date}.log

# Log
echo "$timestamp > +$cmd" >> "$logFile"

