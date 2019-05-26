# Check
if [[ ! "$#" -eq 1 ]]; then
    echo "Wrong argument count"
    exit 1
fi

# Vars
cmd=$1
date=`date '+%Y%m'`
timestamp=`date '+%Y-%m-%d %H:%M:%S'`
logFile=$BACKUPPATH/log/${date}.log

# Log
echo "$timestamp > +$cmd" >> "$logFile"

