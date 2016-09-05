#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import logging
import os
from jenkinsapi.jenkins import Jenkins
from jenkinsapi.credential import SSHKeyCredential

log_level = getattr(logging, 'DEBUG')
logging.basicConfig(level=log_level)
logger = logging.getLogger()

jenkins_url = os.environ.get('JENKINS_URL', 'http://mcp-ci.local:8082/jenkins')
secret_file = os.environ.get('SECRET_FILE', '/home/jenkins/.ssh/jenkins_mcp')
passphrase = os.environ.get('PASSPHRASE', '')
creds_id = os.environ.get('CLUSTERNAME', 'dummy-cluster-name')
admin_user = os.environ.get('ADMIN_USER', 'admin')
admin_pass = os.environ.get('ADMIN_PASS', 'secret')

api = Jenkins(jenkins_url, username=admin_user, password=admin_pass)

# Get a list of all global credentials
creds = api.credentials
logging.info(api.credentials.keys())

creds_desc = 'credentials for Jenkins to access Kubernetes nodes'
cred_dict = {
    'description': creds_desc,
    'userName': '{0}-cluster-key'.format(creds_id),
    'passphrase': passphrase,
    'private_key': secret_file
}
creds[creds_desc] = SSHKeyCredential(cred_dict)
