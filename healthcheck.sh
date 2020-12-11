#!/bin/bash

FILE=/config/config.xml

until test -f $FILE; do sleep 1; done

API=$(xml_grep --text_only 'ApiKey' $FILE)
curl -f "http://localhost:8989/api/system/status?apikey=$API" || exit 1
