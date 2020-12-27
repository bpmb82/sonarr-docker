#!/bin/bash

# ***** SQLite backup sript *****

APP=radarr

# Loop forever and sleep 24 hours after each backup

while true

do

# Set variables like source, destination and name the backup files

DATE=$(date +"%d-%m-%Y")
SOURCE="/config/${APP}.db"
DESTINATION=/backups
NO_BACKUPS=$(ls $DESTINATION | grep .db | wc -l)
BACKUPFILE="${APP}-backup_$DATE.db"
DATETIME=$(date +"%d-%m-%Y %H:%M:%S")

# Variables on where to put the outputfiles

OUTPUTFILE=$DESTINATION/$BACKUPFILE

# Backup actual db file locally in /backups

if test -f "$OUTPUTFILE"; then
  echo "$DATETIME SQLite Backup Script [Info] File exists already, skipping backup.." >> /proc/1/fd/1
else
  sqlite3 $SOURCE ".backup $DESTINATION/$BACKUPFILE"
  echo "$DATETIME SQLite Backup Script [Info] Backup made successfully.." >> /proc/1/fd/1
fi

# Keep last 90(!) backups

if [ $NO_BACKUPS -gt 90 ]; then
  REMOVEFILE=$(ls -t $DESTINATION | tail -1)
  rm -f $DESTINATION$REMOVEFILE
  echo "$DATETIME SQLite Backup Script [Info] Removed backups from more than 90 days ago.." >> /proc/1/fd/1
else
  echo "$DATETIME SQLite Backup Script [Info] We now have $NO_BACKUPS backups so nothing to remove!" >> /proc/1/fd/1
fi

sleep 86400

done
