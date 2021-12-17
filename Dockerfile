FROM solr:8    
    
USER root    
COPY solr/conf /opt/config    
COPY ops/boot.sh /boot.sh    
USER solr    
ENTRYPOINT ["/boot.sh"]    
