#!/bin/bash

# Config file
cfg=~/.backup-config
[[ ! "$BACKUPCONFIG" -eq "" ]] && cfg=$BACKUPCONFIG
echo > $cfg

# Set backup path
read -p "Backup path: " v
echo "export BACKUPPATH=$v" >> $cfg

# Set backup host
read -p "Backup host (username@hostname): " v
echo "export BACKUPHOST=$v" >> $cfg

# Set backup destination
read -p "Backup destination in the backup machine: " v
echo "export BACKUPDEST=$v" >> $cfg