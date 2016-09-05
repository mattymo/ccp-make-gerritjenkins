#!/bin/bash -xe

. config

WORKDIR=$(mktemp -d ./gerrit-resources-XXX)
GIT_TOPIC="add-$CLUSTERNAME"

cd $WORKDIR
git clone "ssh://$GERRIT_SERVER:$GERRIT_PORT/mcp-ci/project-config"
mkdir -p project-config/jenkins/jobs/clusters
#common dir patch on review: https://review.fuel-infra.org/#/c/25753/
#add it manually on custom env
j2 -f env jjb/newcluster.yaml.j2 config > project-config/jenkins/jobs/clusters/$CLUSTERNAME.yaml
cd project-config

#DEBUG
git add *
echo git commit -a -m "New project $CLUSTERNAME"
echo git review -t "add_cluster_$CLUSTERNAME"
