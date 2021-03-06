#!/bin/bash

# Treat unset variables and parameters [...] as an error when performing parameter expansion (substituting).
set -u
# Print a trace of simple commands
# set -x

# If we do not validate the service after it's been (successfully) started,
# while the app does not respond properly to Load Balancer's healthchecks,
# we can be stuck at BeforeAllowTraffic step waiting for Load Balancer to
# route the traffic to the newly deployed instance (timeout = 1h)
#
# ValidateService hook can be very helpful letting us avoid such timeout
# failing appropriately and immediately when the healthcheck path is not responding as expected.

# This simple script should reflect the deployed app setup and healthcheck URL.

INTERVAL=10
CHECK=1
CHECKS_NUM=5
URL="http://localhost:2370"

while [ ${CHECK} -le ${CHECKS_NUM} ]; do
  CLI_HEALTH_CHECK=$(curl -w "%{http_code}" -o /dev/null -s ${URL})
  if [ ${CLI_HEALTH_CHECK} -eq 200 ]; then
    echo "Service is responding at ${URL} with HTTP code 200"
    exit 0
  else
    echo "[check ${CHECK}/${CHECKS_NUM}] Service is NOT responding with HTTP code 200 at ${URL}"
    if [ ${CHECK} -eq ${CHECKS_NUM} ]; then
        exit 1
    fi
    let "CHECK=${CHECK} + 1"
    echo "Waiting ${INTERVAL}s..."
    sleep ${INTERVAL}
 fi
done

exit 1