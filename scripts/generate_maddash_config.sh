#!/bin/bash

#move to script direcory
cd /opt/perfsonar_ps/esnet-perfsonar-mesh

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
cp /etc/maddash/maddash-server/maddash.yaml /etc/maddash/maddash-server/maddash.yaml.bak
cp /opt/perfsonar_ps/esnet-perfsonar-mesh/maddash/maddash.yaml.template /etc/maddash/maddash-server/maddash.yaml
cp /opt/perfsonar_ps/esnet-perfsonar-mesh/maddash/gui_agent_configuration.conf /etc/perfsonar/meshconfig-guiagent.conf
#Try to generate config. If fails, restore backup and exit
CONFIG_OUTPUT=$( /uslib/perfsonar/bin/generate_gui_configuration 2>&1 ) 
echo $CONFIG_OUTPUT
if [ -n "$CONFIG_OUTPUT" ]; then
    cp /etc/maddash/maddash-server/maddash.yaml.bak /etc/maddash/maddash-server/maddash.yaml
    echo "Configuration generation failed due to errors above. Old maddash config restored"
    exit 1
fi 
/etc/init.d/maddash-server restart
