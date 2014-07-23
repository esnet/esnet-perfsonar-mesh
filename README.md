ESnet perfSONAR Mesh Configuration
==================================

This document contains the configuration files used to build the regular tests run internally on ESnet. It can also be used as an example for others wishing to deploy a similar infrastructure on their networks. It contains a set of configuration files that can be used as inputs to the [perfSONAR Mesh Configuration](http://code.google.com/p/perfsonar-ps/wiki/MeshConfigurationInstallation) software. It also contains a set of scripts that can be used to deploy each configuration file as a JSON file on a web server.

Updating the Mesh
-----------------

###Editing Current Mesh Files

Checkout this source code repository then make your changes under the *conf* directory. Commit your changes to this repository and they will automatically be published as JSON [here](http://ps-west.es.net/esnet-mesh_config.json) within 15 minutes.

###Adding New Mesh Files

Any mesh file added to the *conf* directory with the extension *.conf* will automatically get published by the scripts once you commit them.

Deploying
----------
This section is for administrators installing these configuration files and scripts for the first time. If you just want to update the mesh, you can ignore this section.

###System Requirements
 * CentOS Line 6 or greater (other OSes require modifications to scripts)
 * perl-perfSONAR_PS-MeshConfig-BuildJSON (available from perfSONAR Yum)
 * Apache HTTPD

###Installation
You may install the configuration files and scripts from source on a web server you wish to use to publish your configurations as JSON files. The steps to checkout the code and setup the cron script are as follows:
```
cd /opt/perfsonar_ps
git pull https://github.com/esnet/esnet-perfsonar-mesh.git ./esnet-perfsonar-mesh
cp esnet-perfsonar-mesh/scripts/cron-deploy-json /etc/crond.d/cron-deploy-json
```




