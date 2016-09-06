#!/bin/bash -e
# Env vars expected:
# SECRET_FILE, ADMIN_USER, GERRIT_HOST, USERNAME

. config

SECRET_FILE="${SECRET_FILE:-~/keys/jenkins_mcp.pub}"
KEY="$(cat ${SECRET_FILE})"
ADMIN_USER="${ADMIN_USER:-admin}"
USERNAME="${USERNAME:-mcptestuser}"
GERRIT_HOST="${GERRIT_HOST:-review.fuel-infra.org}"

ssh  -p 29418 ${ADMIN_USER}@${GERRIT_HOST} gerrit set-account \
  ${USERNAME} --add-ssh-key "${KEY}"
