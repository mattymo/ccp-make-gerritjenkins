#!/bin/bash -xe

. config

WORKDIR=$(mktemp -d gerrit-resources-XXX)
GIT_TOPIC="add-$CLUSTERNAME"

cd $WORKDIR
git clone $GERRIT_GIT_URL/mcp-ci/project-config

#TODO: Alphabetical order
cat >> project-config/gerrit/projects.yaml << EOF
-
  project: $CLUSTERNAME/inventory
  description: MCP k8s inventory
  acl-config: acls/$CLUSTERNAME/inventory.config

EOF

mkdir -p project-config/gerrit/acls/$CLUSTERNAME
cat > project-config/gerrit/acls/$CLUSTERNAME/inventory.config << EOF
[access "refs/*"]
    read = group Anonymous Users
    read = group Registered Users
    read = group Non-Interactive Users
    read = group Administrators
[access "refs/meta/*"]
    read = group Anonymous Users
    read = group Registered Users
    read = group Administrators
    read = group Non-Interactive Users
[access "refs/meta/config"]
    read = group Anonymous Users
    read = group Registered Users
    read = group Administrators
    read = group Non-Interactive Users
[access "refs/heads/*"]
    abandon = group ${CLUSTERNAME}-core
    abandon = group Change Owner
    create = group ${CLUSTERNAME}-core
    label-Code-Review = -2..+2 group ${CLUSTERNAME}-core
    label-Code-Review = -1..+1 group Registered Users
    label-Verified = -2..+2 group Non-Interactive Users
    label-Workflow = -1..+1 group ${CLUSTERNAME}-core
    rebase = group ${CLUSTERNAME}-core
    rebase = group Change Owner
    submit = group devops-core
    submit = group ${CLUSTERNAME}-ci
[access "refs/tags/*"]
    create = group ${CLUSTERNAME}-core
    pushSignedTag = group ${CLUSTERNAME}-core
    pushMerge = group ${CLUSTERNAME}-core
[receive]
    requireChangeId = true
[submit]
    mergeContent = true
EOF

git -C project-config add gerrit/acls/$CLUSTERNAME/inventory.config
git -C project-config commit -a -m "Add project and ACLs for $CLUSTERNAME"
git -C project-config review -t $GIT_TOPIC

#cd -
#rm -rf $WORKDIR
