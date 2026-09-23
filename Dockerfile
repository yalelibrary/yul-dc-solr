FROM solr:9.10.1

# The ICU tokenizer/folding filters used in schema.xml live in the
# analysis-extras module. Solr 9 loads modules via SOLR_MODULES rather
# than <lib> directives in solrconfig.xml.
ENV SOLR_MODULES=analysis-extras

USER root
COPY solr/conf /opt/config
COPY ops/boot.sh /boot.sh
USER solr
