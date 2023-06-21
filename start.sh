#!/bin/bash

if [ $ENABLE_BACKUP = "1" ]; then
  /app/sonarr/bin/backup.sh &
fi

/app/sonarr/Sonarr -nobrowser -data=/config