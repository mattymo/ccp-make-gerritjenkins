#!/bin/bash

set -ex

env

export ENV_NAME="k8s-env-$BUILD_TAG"
#START FUEL-DEVOPS OPTS
export IMAGE_PATH="/home/jenkins/workspace/cloud-images/$IMAGE"
export DONT_DESTROY_ON_SUCCESS=1
export VLAN_BRIDGE="vlan450"
export SLAVES_COUNT=$PARAM_SLAVES_COUNT
source /home/jenkins/fuel-devops-3.0/bin/activate
#END FUEL-DEVOPS OPTS
export DEPLOY_METHOD="kargo"
export WORKSPACE="/home/jenkins/workspace"
echo "Running on $NODE_NAME: $ENV_NAME"

bash -x "utils/jenkins/run_k8s_deploy_test.sh"
deactivate
