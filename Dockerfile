FROM solr:8    
    
USER root    
RUN apt update && apt install zip    
COPY solr/conf /opt/config    
COPY ops/boot.sh /boot.sh    
RUN zip -q -d /opt/solr/contrib/prometheus-exporter/lib/log4j-core-2.14.1.jar org/apache/logging/log4j/core/lookup/JndiLookup.class        
RUN zip -q -d  /opt/solr/server/lib/ext/log4j-core-2.14.1.jar org/apache/logging/log4j/core/lookup/JndiLookup.class        
USER solr    
ENTRYPOINT ["/boot.sh"]    
