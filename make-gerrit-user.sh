#!/bin/bash -e
# Env vars expected:
# CLUSTERNAME, SECRET_FILE, ADMIN_USER, USERNAME

. config

SECRET_FILE="${SECRET_FILE:-~/keys/jenkins_mcp.pub}"
KEY="$(cat ${SECRET_FILE})"
$ADMIN_USER="${ADMIN_USER:-admin}"
$USERNAME="${USERNAME:-mcptestuser}"

ssh  -p 29418 ${ADMIN_USER}@review.fuel-infra.org gerrit create-account \
  --group "Non-interactive Users" --full-name "MCP Test User" \
  --email ${ADMIN_USER}@mirantis.com --ssh "${KEY}" \
  --http-password changeme ${USERNAME}
