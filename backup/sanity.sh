#!/bin/bash

# Sanity checks

[[ ! -d "$BACKUP_PATH" ]] && exit 1
[[ ! -d "$BACKUP_PATH/bin" ]] && exit 1
[[ ! -d "$BACKUP_PATH/cfg" ]] && exit 1
[[ ! -d "$BACKUP_PATH/log" ]] && exit 1
[[ ! -d "$BACKUP_PATH/tmp" ]] && exit 1

[[ "$BACKUP_PATH" == "" ]] && exit 1
[[ "$BACKUP_HOST" == "" ]] && exit 1
[[ "$BACKUP_TYPE" == "" ]] && exit 1
[[ "$BACKUP_DEST" == "" ]] && exit 1

exit 0
