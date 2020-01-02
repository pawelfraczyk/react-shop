#!/bin/bash

# During this deployment lifecycle event, the AWS CodeDeploy agent
# copies the application revision files to a temporary location:
# /opt/codedeploy-agent/deployment-root/deployment-group-id/deployment-id/deployment-archive

# https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html
# supported variables set by the CodeDeploy agent:
# APPLICATION_NAME
# DEPLOYMENT_ID
# DEPLOYMENT_GROUP_NAME
# DEPLOYMENT_GROUP_ID
# LIFECYCLE_EVENT

# Exit immediately if a pipeline [...] returns a non-zero status.
set -e
# Treat unset variables and parameters [...] as an error when performing parameter expansion (substituting).
set -u
# Print a trace of simple commands
set -x

# env
# pwd

# EC2s are configured with instance profile (a specific role) and all the required policies.

# Replace "your_instance_name" with name of your instance.
INSTANCE_NAME="CodeDeployEc2"

# Environment variables retrieved from System Manager / Parameter Store
REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".region")
VARS=$(aws --region $REGION ssm get-parameters-by-path --recursive --path /bgshop/${INSTANCE_NAME}/staging --with-decryption | jq -r '.Parameters | .[] | .Name + "=" + .Value' | sed -e s#/bgshop/${INSTANCE_NAME}/staging/##g)
for envvar in ${VARS}; do
  export $envvar;
done
cd /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/${DEPLOYMENT_ID}/deployment-archive
COMPOSE="docker-compose -p ${INSTANCE_NAME} -f docker-compose.yml"
${COMPOSE} build
${COMPOSE} up -d
# Remove unused data, do not prompt for confirmation
docker image prune -f