#!/bin/bash -xe

. config

WORKDIR=$(mktemp ./gerrit-resources-XXX)
GIT_TOPIC="add-$CLUSTERNAME"

cd $WORKDIR
git clone "$gerrit_server/fuel-infra/project-config"
cp -R jjb/common/* project-config/jobs/common/
j2 -f env jjb/newcluster.yaml.j2 ./config > project-config/jobs/clusters/$CLUSTERNAME.yaml
cd project-config
git add *
git commit -a -m "New project $CLUSTERNAME"
git review -t "add_cluster_$CLUSTERNAME"
