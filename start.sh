#!/bin/bash

if [ $ENABLE_BACKUP = "1" ]; then
  /app/sonarr/bin/backup.sh &
fi

mono --debug /app/sonarr/bin/Sonarr.exe -nobrowser -data=/config