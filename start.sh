#!/bin/bash

if [ $ENABLE_BACKUP = "1" ]; then
  /opt/backup.sh &
fi

mono --debug /opt/NzbDrone/NzbDrone.exe -nobrowser -data=/config
