FROM solr:8

COPY solr/conf /opt/config
COPY ops/boot.sh /boot.sh
USER root
