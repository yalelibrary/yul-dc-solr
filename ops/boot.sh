#!/bin/bash -ex
if [ ! -z "$DYNATRACE_TOKEN" ];then
  curl -Ls -H "Authorization: Api-Token ${DYNATRACE_TOKEN}" 'https://nhd42358.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?arch=x86&flavor=default' > installer.sh

  /bin/sh installer.sh --set-app-log-content-access=true --set-infra-only=true --set-host-group=DC --set-host-name=${CLUSTER_NAME}-solr 2>&1 & 
fi
echo "hello"
su solr -c 'cp -rn /opt/config/ /var/solr/data/${SOLR_CORE}/conf && touch /var/solr/data/${SOLR_CORE}/core.properties && exec solr -f'
