#!/bin/bash -xe

. config

WORKDIR=$(mktemp ./gerrit-resources-XXX)
GIT_TOPIC="add-$CLUSTERNAME"

cd $WORKDIR
git clone https://review.fuel-infra.org/fuel-infra/jeepyb-config
cat >> jeepyb-config/projects.yaml << EOF
-
  project: $CLUSTERNAME/inventory
  description: MCP k8s inventory
  acl-config: acls/$CLUSTERNAME/inventory.config

EOF
git -C jeepyb-config commit -a -m "Added new project $CLUSTERNAME/inventory"
git -C jeepyb-config review -t add-$CLUSTERNAME

git clone https://review.fuel-infra.org/fuel-infra/project-configs
mkdir -p project-configs/$CLUSTERNAME
cat >> project-configs/$CLUSTERNAME/$CLUSTERNAME.config << EOF
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

cat >> project-configs/$CLUSTERNAME/inventory.config << EOF
[access "refs/heads/*"]
    abandon = group ${CLUSTERNAME}-core
    abandon = group Change Owner
    create = group ${CLUSTERNAME}-core
    label-Code-Review = -2..+2 group ${CLUSTERNAME}-core
    label-Code-Review = -1..+1 group Registered Users
    label-Verified = -2..+2 group Non-Interactive Users
    label-Verified = -2..+2 group ${CLUSTERNAME}-core
    label-Workflow = -1..+1 group ${CLUSTERNAME}-core
    rebase = group ${CLUSTERNAME}-core
    rebase = group Change Owner
    submit = group devops-core
    submit = group ${CLUSTERNAME}-ci
    submit = group ${CLUSTERNAME}-core
[access "refs/tags/*"]
    create = group ${CLUSTERNAME}-core
    pushSignedTag = group ${CLUSTERNAME}-core
    pushMerge = group ${CLUSTERNAME}-core
[receive]
    requireChangeId = true
[submit]
    mergeContent = true
[access]
    inheritFrom = $CLUSTERNAME
EOF
git -C project-configs git add $CLUSTERNAME/$CLUSTERNAME.config $CLUSTERNAME/inventory.config 
git -C project-configs commit -a -m "Add ACLs for $CLUSTERNAME"
git -C project-configs review -t $GIT_TOPIC

