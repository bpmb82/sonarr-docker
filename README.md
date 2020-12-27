# sonarr-docker

Sonarr image, updated weekly, running the latest stable version of Sonarr. 

Automatically grabs the API key to do a healthcheck

## Environment

ENABLE_BACKUP=1

Creates daily backups of the database to /backups which you can bind to a local mount

## docker-compose

```

version: '3.3'

services:


  sonarr:
    image: bpmbee/docker-sonarr:latest
    container_name: sonarr
    environment:
      - TZ=Europe/Amsterdam
      - ENABLE_BACKUP=1 # Optional
    volumes:
      - /local_path/config:/config/
      - /local_path/backups:/backups
      - /path_to_your_tv_dir:/tv
      - /path_to_your_completed_downloads_dir:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped
```
