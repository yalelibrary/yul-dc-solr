FROM solr:9.10.1

ENV SOLR_MODULES=analysis-extras

USER root
COPY solr/conf /opt/config
COPY ops/boot.sh /boot.sh
USER solr
