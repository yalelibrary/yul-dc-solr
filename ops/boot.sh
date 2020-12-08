#!/bin/bash -ex
if [ ! -z "$DYNATRACE_TOKEN" ];then
  curl -Ls -H "Authorization: Api-Token ${DYNATRACE_TOKEN}" 'https://nhd42358.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?arch=x86&flavor=default' > /tmp/installer.sh

  /bin/sh /tmp/installer.sh --set-app-log-content-access=true --set-infra-only=true --set-host-group=DC --set-host-name=${CLUSTER_NAME}-solr NON_ROOT_MODE=0 2>&1 & 
fi
su solr -c 'docker-entrypoint.sh solr-foreground'

