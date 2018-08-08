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

#get list of files
for f in *.conf
do
    MESH=`echo "$f" | sed 's/\(.\)\.conf/\1/'`
    echo "Building ${MESH}.json"
    /usr/lib/perfsonar/bin/build_json --input $f --output /tmp/${MESH}.json
    if [ $? != 0 ]; then
       echo "Error generating JSON file ${MESH}.json"
    else
       cp -f /tmp/${MESH}.json /var/www/html/${MESH}.json
       rm -f /tmp/${MESH}.json
       echo "New JSON file available ${MESH}.json"
     fi
     echo ""
done

#copy psconfig files
cd ../psconfig
mkdir -p /var/www/html/psconfig
cp -f *.json /var/www/html/psconfig/