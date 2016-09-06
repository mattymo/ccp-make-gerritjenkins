#!/bin/bash -xe

. config

GIT_TOPIC="add-$CLUSTERNAME"

git clone "${GERRIT_GIT_URL}/mcp-ci/project-config"
mkdir -p project-config/jenkins/jobs/clusters
#common dir patch on review: https://review.fuel-infra.org/#/c/25753/
#add it manually on custom env
j2 -f env jjb/newcluster.yaml.j2 config > project-config/jenkins/jobs/clusters/$CLUSTERNAME.yaml
cd project-config

#DEBUG
git add *
git commit -a -m "New project $CLUSTERNAME"
git review -t "add_cluster_$CLUSTERNAME"
