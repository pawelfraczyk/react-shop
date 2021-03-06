#!/bin/bash

# During this deployment lifecycle event, the AWS CodeDeploy agent
# copies the application revision files to a temporary location:
# /opt/codedeploy-agent/deployment-root/deployment-group-id/deployment-id/deployment-archive

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

# CodeDeploy stores the info about the most recent deployment in the following file:
#   /opt/codedeploy-agent/deployment-root/deployment-instructions/${DEPLOYMENT_GROUP_ID}_most_recent_install
# It consists of the file url to the last deployment, with the variables properly resolved:
#   /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/${DEPLOYMENT_ID}
# This previous deployment directory is used by the ApplicationStop hook,
# since it's triggered before DownloadBundle
# See: appspec.yml for more details.

# Replace "your_instance_name" with name of your instance
DIR=$(cat /opt/codedeploy-agent/deployment-root/deployment-instructions/${DEPLOYMENT_GROUP_ID}_most_recent_install)
cd $DIR/deployment-archive
COMPOSE="docker-compose -p ${APPLICATION_NAME} -f docker-compose.yml"
${COMPOSE} down | true

# NOTE:
#   ${COMPOSE} down | true
#   should always return an RC zero in order to avoid the ApplicationStop Hook failures; it's fairly safe and very simple.
docker image prune -fa