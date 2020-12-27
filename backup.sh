#!/bin/bash

# ***** SQLite backup sript *****

APP=sonarr

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
  echo "$DATETIME SQLite Backup Script | File exists already, skipping backup.." >> /proc/1/fd/1
else
  sqlite3 $SOURCE ".backup $DESTINATION/$BACKUPFILE"
  echo "$DATETIME SQLite Backup Script | Backup made successfully.." >> /proc/1/fd/1
fi

# Keep last 30 backups

if [ $NO_BACKUPS -gt 30 ]; then
  REMOVEFILE=$(ls -t $DESTINATION | tail -1)
  rm -f $DESTINATION$REMOVEFILE
  echo "$DATETIME SQLite Backup Script | Removed backups from more than 30 days ago.." >> /proc/1/fd/1
else
  echo "$DATETIME SQLite Backup Script | We now have $NO_BACKUPS backups so nothing to remove!" >> /proc/1/fd/1
fi

sleep 86400

done
