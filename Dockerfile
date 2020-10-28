FROM solr:8

COPY solr/conf /opt/config

COPY --from=nhd42358.live.dynatrace.com/linux/oneagent-codemodules:all / /
ENV LD_PRELOAD /opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so