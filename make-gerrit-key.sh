#!/bin/bash -e
# Env vars expected:
# SECRET_FILE, ADMIN_USER, GERRIT_HOST, USERNAME

. config

SECRET_FILE="${SECRET_FILE:-~/keys/jenkins_mcp.pub}"
ADMIN_USER="${ADMIN_USER:-admin}"
USERNAME="${USERNAME:-mcptestuser}"
GERRIT_HOST="${GERRIT_HOST:-review.fuel-infra.org}"
GERRIT_PORT="${GERRIT_PORT:-29418}"

cat "${SECRET_FILE}" | ssh -p ${GERRIT_PORT} ${ADMIN_USER}@${GERRIT_HOST} \
gerrit set-account ${USERNAME} --add-ssh-key -
