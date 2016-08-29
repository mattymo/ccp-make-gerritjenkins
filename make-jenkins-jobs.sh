#!/bin/bash -xe

. config

WORKDIR=$(mktemp ./gerrit-resources-XXX)
GIT_TOPIC="add-$CLUSTERNAME"

cd $WORKDIR
git clone https://review.fuel-infra.org/fuel-infra/project-config
#TODO
#Something like this:
# for file in jjb/*.j2;do j2 -f env $file ./config > project-config/jobs/dst;done
# copy other files
# add all
# git review
