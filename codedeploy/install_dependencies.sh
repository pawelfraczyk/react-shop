#!/bin/bash

# Exit immediately if a pipeline [...] returns a non-zero status.
set -e
# Treat unset variables and parameters [...] as an error when performing parameter expansion (substituting).
set -u
# Print a trace of simple commands
set -x

# During this deployment lifecycle event, the AWS CodeDeploy agent
# copies the application revision files to a temporary location:
# /opt/codedeploy-agent/deployment-root/deployment-group-id/deployment-id/deployment-archive

# https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html
# supported variables:
# APPLICATION_NAME
# DEPLOYMENT_ID
# DEPLOYMENT_GROUP_NAME
# DEPLOYMENT_GROUP_ID
# LIFECYCLE_EVENT

if ! [ -x /usr/bin/docker-compose ]; then
    echo Install docker-compose
    curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
    chmod +x /usr/bin/docker-compose
fi