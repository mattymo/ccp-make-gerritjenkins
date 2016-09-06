#!/bin/bash -e
# Env vars expected:
# SECRET_FILE, ADMIN_USER, GERRIT_HOST,
# USERNAME, USERMAIL, USERFULLNAME

. config

SECRET_FILE="${SECRET_FILE:-~/keys/jenkins_mcp.pub}"
KEY="$(cat ${SECRET_FILE})"
ADMIN_USER="${ADMIN_USER:-admin}"
USERMAIL="${USERMAIL:-mcptestuser@mirantis.com}"
USERNAME="${USERNAME:-mcptestuser}"
USERPASS="${USERPASS:-changeme}"
USERFULLNAME="${USERFULLNAME:-MCP\ Test\ User}"
USERGROUP="${USERGROUP:-Non-interactive\ Users}"
GERRIT_HOST="${GERRIT_HOST:-review.fuel-infra.org}"

ssh  -p 29418 ${ADMIN_USER}@${GERRIT_HOST} gerrit create-account \
  --group "${USERGROUP}" --full-name "${USERFULLNAME}" \
  --email ${USERMAIL} --ssh-key "${KEY}" \
  --http-password "${USERPASS}" ${USERNAME}
