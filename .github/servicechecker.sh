#!/bin/bash

set -euo pipefail

# Helper function to runs a polling-based waiter to check for when a service has resolved it's IP address in Kubernetes. Usually
# takes about a minute. Can be re-used for any cluster, namespace or service, it just assumed the cluster is already authenticated to with kubectl.

# Where:
# $1: seconds to run the check for
# $2: namespace
# $3: servicename

service_healthcheck() {

    LINK_HTTP_CODE=$(kubectl -n si-assessment-ie3 get svc -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
    echo "INFO: $LINK_HTTP_CODE found for $SERVICE_NAME"

    if [ "$LINK_HTTP_CODE" == "<pending>" ]
    then
        echo "1" >> /tmp/url-responses
    else
        echo "0" >> /tmp/url-responses
    fi

    FAILURE_NUMBER=$(cat /tmp/url-responses | { grep "1" | wc -l | xargs || true; } )
    echo "INFO: FAILURE_NUMBER found to be $FAILURE_NUMBER"

    rm /tmp/url-responses

    [[ $FAILURE_NUMBER == 0 ]] && echo "SUCCESS: All services returned ips successfully, listed below (note EXTERNAL-IP key)"
    kubectl -n $NAMESPACE get svc
    exit 0
}

main() {

    echo "INFO: Running service checks for $SECS_TO_CHECK seconds."

    COUNT=0

    while [ "$COUNT" -lt $SECS_TO_CHECK ]
    do
        service_healthcheck
        COUNT=$((COUNT+1))
        sleep 1
    done

    echo "ERROR: Endpoints did not return their service IP"
    exit 1

}

export SECS_TO_CHECK=$1        # < 60 (minutes) >
export NAMESPACE=$2            # < any-namespace >
export SERVICE_NAME="${@:3}"  # < name-of-service to check >

# $1: seconds to run the check for
# $2: namespace
# $3: servicename

main
