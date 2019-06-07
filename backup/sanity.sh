#!/bin/bash

# Sanity checks

[[ ! -d "$BACKUPPATH" ]] && exit 1
[[ ! -d "$BACKUPPATH/bin" ]] && exit 1
[[ ! -d "$BACKUPPATH/log" ]] && exit 1

[[ "$BACKUPPATH" == "" ]] && exit 1
[[ "$BACKUPHOST" == "" ]] && exit 1
[[ "$BACKUPDEST" == "" ]] && exit 1

exit 0