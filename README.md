Set up Gerrit and Jenkins jobs for fuel-ccp-installer

Preparation Workflow:
  # Generate (or import) an SSH key (TODO)
  # Modify config file with your k8s cluster name
  # Create Gerrit and Jenkins non-interactive users (TODO)
  # Create Gerrit project for k8s cluster config (1 per cluster)
  # Create Jenkins jobs for managing a k8s cluster (a set of jobs per cluster)
  # Set up Gerrit trigger in Jenkins for automatically deploying on commit
  # Set up CI for testing new changes

Once the Jenkins jobs and Gerrit projects are in place with the proper hooks, the
user can provision nodes and then deploy fuel-ccp-installer. 

Initial deployment has two routes:
Method A:
  # Commit an `inventory.cfg` (and optionally `custom.yaml`) file to the inventory repo[0]
  # Run Jenkins job CLUSTERNAME_k8s_deploy 
Method B:
  # Run Jenkins job CLUSTERNAME_k8s_deploy, providing a list of SLAVE_IPS


[0[ See `example-inventory.cfg` as an example.
