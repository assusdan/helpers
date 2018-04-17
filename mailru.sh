#!/bin/bash
                                                                                          #
# Copyright (c) 2018 - 2019 Danya Suslov
# https://github.com/assusdan                                                             #
                                                                                          # Don't Touch This
											  
URL=$1
FILENAME=$2

# ARGS

if [ $ARG_COUNT -lt "2" ]
then
  echo "Not enough arguments were specified, run the script again with proper arguments"
  exit 1
fi

# Start Getting File

URLPART0=$(wget --quiet -O - $URL | grep -o '"weblink_get":\[[^]]\+\]' | sed 's/.*"url":"\([^"]\+\)".*/\1/')
URLPART1=$(echo $URL | awk -F '/public/' '{print $2}')
URLPART2=$(wget --quiet -O - "https://cloud.mail.ru/api/v2/tokens/download" | sed 's/.*"token":"\([^"]\+\)".*/\1/')
wget --no-check-certificate --referer=$URL "$URLPART0/$URLPART1/$FILENAME?key=$URLPART2" -O $FILENAME
