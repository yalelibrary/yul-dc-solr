FROM solr:8

COPY solr/conf /opt/config

COPY --from=nhd42358.live.dynatrace.com/linux/oneagent-codemodules:all / /
RUN echo "/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so" > /etc/ld.so.preload