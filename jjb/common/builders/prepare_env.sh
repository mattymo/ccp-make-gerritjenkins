#!/bin/bash

set -ex

export PATH=/bin:/usr/bin:/sbin:/usr/sbin:${PATH}

ACT=0

function update_devops () {
  ACT=1
  VIRTUAL_ENV=/home/jenkins/venv-fuel-devops-3.0
  REPO_NAME=${1}
  BRANCH=${2}

  if [[ -d "${VIRTUAL_ENV}" ]] && [[ "${FORCE_DELETE_DEVOPS}" == "true" ]];
then
    echo "Delete venv from ${VIRTUAL_ENV}"
    rm -rf ${VIRTUAL_ENV}
  fi

  if [ -f ${VIRTUAL_ENV}/bin/activate ]; then
    source ${VIRTUAL_ENV}/bin/activate
    echo "Python virtual env exist"
  else
    rm -rf ${VIRTUAL_ENV}
    virtualenv --no-site-packages  ${VIRTUAL_ENV}
    source ${VIRTUAL_ENV}/bin/activate
  fi

  #
  # fuel-devops use ~/.devops directory to store log configuration
  # we need to delete log.yaml befeore update to get it in current
  # version
  #
  test -f ~/.devops/log.yaml && rm ~/.devops/log.yaml

  # Prepare requirements file
  if [[ -n "${VENV_REQUIREMENTS}" ]]; then
    echo "Install with custom requirements"
    echo "${VENV_REQUIREMENTS}" >"${WORKSPACE}/venv-requirements.txt"
  else
    if ! curl -fsS
"https://raw.githubusercontent.com/openstack/${REPO_NAME}/${BRANCH}/fuel_ccp_tests/requirements.txt"
> "${WORKSPACE}/venv-requirements.txt"; then
      echo "Problem with downloading requirements"
      exit 1
    fi
  fi

  # Upgrade pip inside virtualenv
  pip install pip --upgrade

  pip install -r "${WORKSPACE}/venv-requirements.txt" --upgrade
  echo "=============================="
  pip freeze
  echo "=============================="
  django-admin.py syncdb --settings=devops.settings --noinput
  django-admin.py migrate devops --settings=devops.settings --noinput
  deactivate

}

function download_images () {
  ACT=1
  TARGET_CLOUD_DIR=/home/jenkins/workspace/cloud-images
  mkdir -p ${TARGET_CLOUD_DIR}
}

if [[ ${download_images} == "true" ]]; then
  download_images
fi

# DevOps
if [[ ${update_devops} == "true" ]]; then
  update_devops "fuel-ccp-tests" "master"
fi

if [[ ${install_ansible} == "true" ]]; then
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 7BB9C367
  sudo apt-add-repository -y 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main'
  sudo apt-get update
  sudo apt-get install -y ansible python-netaddr sshpass
fi

if [ ${ACT} -eq 0 ]; then
  echo "No action selected!"
  exit 1
fi

