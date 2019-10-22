#!/bin/bash

#move to script direcory
cd /opt/perfsonar_ps/esnet-perfsonar-mesh/conf

#compare revisions unless we want to force an update
if [ "$1" != "force" ]; then
    #Update remote references so can compare revisions
    git remote update
    if [ $? != 0 ]; then
        echo "Error performing git remote update. Exiting"
    fi
    LOCAL_REV=`git rev-parse "@{0}"`
    REMOTE_REV=`git rev-parse "@{u}"`
    if [ "$LOCAL_REV" == "$REMOTE_REV" ]; then
        echo "No changes since last run. Exiting."
        exit 0
    fi
fi

#if here, then time to update
git pull

#copy psconfig files
cd ../psconfig
mkdir -p /var/www/html/psconfig
cp -f *.json /var/www/html/psconfig/