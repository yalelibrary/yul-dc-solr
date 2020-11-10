FROM solr:8

CMD whoami
RUN apt-get update && apt install curl -y && apt clean
COPY solr/conf /opt/config
COPY ops/boot.sh /boot.sh
RUN chmod 755 /boot.sh
CMD /boot.sh
