#!/bin/bash

# Sanity checks

[[ ! -d "$BACKUPPATH" ]] && exit 1
[[ ! -d "$BACKUPPATH/bin" ]] && exit 1
[[ ! -d "$BACKUPPATH/log" ]] && exit 1

[[ "$BACKUPPATH" -eq "" ]] && exit 1
[[ "$BACKUPHOST" -eq "" ]] && exit 1
[[ "$BACKUPDEST" -eq "" ]] && exit 1

exit 0