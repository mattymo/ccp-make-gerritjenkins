#!/bin/bash -xe

. config

WORKDIR=$(mktemp -d ./gerrit-resources-XXX)
GIT_TOPIC="add-$CLUSTERNAME"

cd $WORKDIR
git clone "${GERRIT_SERVER}/mcp-ci/project-config"
cp -R ../jjb/common project-config/jenkins/jobs/
mkdir -p project-config/jenkins/jobs/clusters
j2 -f env ../jjb/newcluster.yaml.j2 ../config > project-config/jenkins/jobs/clusters/$CLUSTERNAME.yaml
cd project-config

#DEBUG
#git add *
#git commit -a -m "New project $CLUSTERNAME"
#git review -t "add_cluster_$CLUSTERNAME"
