#!/bin/bash

set -euo pipefail

# Helper function to run basic http integrity checks on an endpoint, call it like:
# healthchecker.sh 15 user:pass http://localhost:8080. Stages results in /tmp/url-responses.

# Where:
# $1: seconds to run the check for
# $2: basic auth header
# $3: endpoint to validate for 200 response

endpoint_healthcheck() {

    for url in $URLS
    do

        LINK_HTTP_CODE=$(curl -u $AUTH_HEADERS -I -s -m 5 -o /dev/null -w "%{http_code}" $url || echo "500" )
        echo "INFO: $LINK_HTTP_CODE found for $url"

        if [ "$LINK_HTTP_CODE" -eq 200 ]
        then
            echo "0" >> /tmp/url-responses
        else
            echo "1" >> /tmp/url-responses
        fi

    done

    FAILURE_NUMBER=$(cat /tmp/url-responses | { grep "1" | wc -l | xargs || true; } )
    echo "INFO: FAILURE_NUMBER found to be $FAILURE_NUMBER"

    rm /tmp/url-responses

    [[ $FAILURE_NUMBER == 0 ]] && echo "SUCCESS: All endpoints returned 200" && exit 0 || true
}

main() {

    echo "INFO: Running url checks for $SECS_TO_CHECK seconds."

    COUNT=0

    while [ "$COUNT" -lt $SECS_TO_CHECK ]
    do
        endpoint_healthcheck
        COUNT=$((COUNT+1))
        sleep 1
    done

    echo "ERROR: Endpoints did not return 200"
    exit 1

}

SECS_TO_CHECK=$1  # < 60 (minutes) >
AUTH_HEADERS=$2   # < automation-user:automation-user >
URLS="${@:3}"     # < List of URLs >

main
