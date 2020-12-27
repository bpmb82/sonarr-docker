# sonarr-docker

Sonarr image, updated weekly, running the latest stable version of Sonarr. 

Automatically grabs the API key to do a healthcheck

## Environment

ENABLE_BACKUP=1

Creates daily backups of the database to /backups which you can bind to a local mount
