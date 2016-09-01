#!/bin/bash -x

set -e
env

export ENV_NAME="env-k8s-$BUILD_TAG"
export DEPLOY_METHOD="kargo"

# START FUEL-DEVOPS CONFIG
IMAGE_PATH="/home/jenkins/workspace/cloud-images/ubuntu-1604-server-13.qcow2"
export DONT_DESTROY_ON_SUCCESS=1
#export VLAN_BRIDGE="" # custom bridge connected to vlan
export SLAVES_COUNT="3"
export FUEL_DEVOPS_INSTALLATION_DIR="/home/jenkins/venv-fuel-devops-3.0"
source ${FUEL_DEVOPS_INSTALLATION_DIR}/bin/activate
# END FUEL-DEVOPS CONFIG

export WORKSPACE="/home/jenkins/workspace"
echo "Running on $NODE_NAME: $ENV_NAME"
bash -ex "utils/jenkins/run_k8s_deploy_test.sh"
echo "[TODO] We need some check of K8s deployment here."
#fuel-devops specific
echo "Cleaning up:"
dos.py erase $ENV_NAME

