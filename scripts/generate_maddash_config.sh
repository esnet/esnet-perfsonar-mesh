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
cp /opt/perfsonar_ps/esnet-perfsonar-mesh/maddash/gui_agent_configuration.conf /opt/perfsonar_ps/mesh_config/etc/gui_agent_configuration.conf
#Try to generate config. If fails, restore backup and exit
/opt/perfsonar_ps/mesh_config/bin/generate_gui_configuration || { cp /etc/maddash/maddash-server/maddash.yaml.bak /etc/maddash/maddash-server/maddash.yaml; exit 1; }
/etc/init.d/maddash-server restart
