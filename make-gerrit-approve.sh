#!/bin/bash -e

. config

ADMIN_USER="${ADMIN_USER:-admin}"
GERRIT_HOST="${GERRIT_HOST:-review.fuel-infra.org}"
GERRIT_PORT="${GERRIT_PORT:-29418}"
BRANCH="${BRANCH:-origin/master}"

[ "${COMMIT}" -a "${PROJECT}" ] || exit 1

ssh -p ${GERRIT_PORT} ${ADMIN_USER}@${GERRIT_HOST} \
gerrit review --project ${PROJECT} --branch ${BRANCH} \
--verified +1 --code-review +2 --submit "${COMMIT}"
