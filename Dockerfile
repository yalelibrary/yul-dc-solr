FROM solr:8

USER root
RUN apt-get update && apt install curl -y && apt clean
COPY solr/conf /opt/config
COPY ops/boot.sh /boot.sh
RUN chmod 755 /boot.sh
USER solr
