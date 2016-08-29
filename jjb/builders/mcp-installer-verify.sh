#!/bin/bash

set -ex

env

export DEPLOY_METHOD="kargo"
export WORKSPACE="/home/jenkins/workspace"
echo "Running on $NODE_NAME: $ENV_NAME"
bash -x "utils/jenkins/run_k8s_verify.sh"
