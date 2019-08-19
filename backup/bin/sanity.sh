#!/bin/bash

# Sanity checks

## Variables
[[ "$BACKUP_PATH" == "" ]] && exit 1
[[ "$BACKUP_TYPE" == "" ]] && exit 1
[[ "$BACKUP_DEST" == "" ]] && exit 1

## Per type validation
case $BACKUP_TYPE in
s3)
    [[ "$AWS_SHARED_CREDENTIALS_FILE" == "" ]] && exit 1
    [[ "$BACKUP_S3_BUCKET" == "" ]] && exit 1
    ;;
scp)
    [[ "$BACKUP_HOST" == "" ]] && exit 1
    ;;
esac

## Check if they are directories
[[ ! -d "$BACKUP_PATH" ]] && exit 1
[[ ! -d "$BACKUP_PATH/bin" ]] && exit 1
[[ ! -d "$BACKUP_PATH/cfg" ]] && exit 1
[[ ! -d "$BACKUP_PATH/log" ]] && exit 1
[[ ! -d "$BACKUP_PATH/tmp" ]] && exit 1

exit 0
