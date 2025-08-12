#!/bin/bash -ex
if [ ! -z "${SOLR_CORE}" ];then
  cp -rn /opt/config/ /var/solr/data/${SOLR_CORE}/conf
  touch /var/solr/data/${SOLR_CORE}/core.properties
  chown -R solr: /var/solr/data
fi
export SOLR_HEAP="${SOLR_HEAP:=62g}"
export SOLR_OPTS="-Dlog4j2.formatMsgNoLookups=true"
ulimit -n 65000 && docker-entrypoint.sh solr-foreground
