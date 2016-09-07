#!/bin/bash -e
# If a commit is not specified, mark the unmerged commits both
# "Verified +1" and "Code-Review +2" and submit them for merging.

. config

GERRIT_USER="${GERRIT_USER:-admin}"
GERRIT_HOST="${GERRIT_HOST:-mcp-ci.local}"
GERRIT_PORT="${GERRIT_PORT:-29418}"
PROJECT="${PROJECT}" # Optional
BRANCH="${BRANCH}" # Optional
COMMIT="${COMMIT:-$1}" # Required

if [ -n "$PROJECT" ]; then
  project_opt="--project ${PROJECT}"
fi
if [ -n "$BRANCH" ]; then
  branch_opt="--branch ${BRANCH}"
fi
if [ -z "$COMMIT" ]; then
  echo "ERROR: specify a commit ref by hash or change ID" 1>&2
  exit 1
fi

# Get commit hash if change ID is proposed
if [[ "$COMMIT" =~ ^Ib.* || "$COMMIT" =~ ^-?[0-9]+$ ]]; then
  COMMIT=$(ssh -p ${GERRIT_PORT} ${GERRIT_USER}@${GERRIT_HOST} \
gerrit query --current-patch-set change:${COMMIT} | \
awk -F": " '/revision/ {print $2}')
fi
ssh -p ${GERRIT_PORT} ${GERRIT_USER}@${GERRIT_HOST} \
gerrit review $project_opt $branch_opt \
--verified +2 --code-review +2 --submit "${COMMIT}"
