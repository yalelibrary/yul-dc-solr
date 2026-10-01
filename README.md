# yul-dc-solr
Solr for Digital Collections

The image is built from the official `solr:9.10.1` image with the config set in
`solr/conf` baked in at `/opt/config`. The `analysis-extras` module (ICU
tokenizer and folding filters used by the schema) is enabled via
`SOLR_MODULES=analysis-extras` in the Dockerfile.

## Solr Instance
Solr is run on an EC2 instance.  Manual configuration and file copying required for changing instances used in Test, Demo, UAT, and Production.  

## Running Solr Locally

### Prerequisites
- Download [Docker Desktop](https://www.docker.com/products/docker-desktop) and log in


### Docker Development Setup
#### If this is your first time working in this repo, build the base service (dependencies, etc. that don't change)
  ``` bash
  docker build . -f Dockerfile
  ```

### Starting the app
- Start the solr service with camerata
  ``` bash
  cam up solr
  ```

- To specify the solr version to work with when running with blacklight or management containers - export the SOLR_VERSION variable during the up command as such
  ``` bash
  SOLR_VERSION=v1.0.16 cam up blacklight
  ```

  - Access the solr instance at `http://localhost:8983`

### Smoke testing the image

CI runs `ops/smoke-test.sh` against every build before pushing it. The script
starts a container, creates a core from `/opt/config`, indexes a document with
accented text and searches for it through the `search` and `iiif_search`
handlers. Run it locally against a freshly built image:

```bash
docker build -t dc-solr:local .
ops/smoke-test.sh dc-solr:local
```

### Making a new release

Build the image as noted, tag with new version.

```
docker tag <image sha> yalelibraryit/dc-solr:v1.0.1

```
Push newly tagged image to dockerhub

```
docker push yalelibraryit/dc-solr:v1.0.1
```

Create tag and the release in github to keep repository current and in line with EC2 instances.

Since Solr is a stateful application, announce deployment in the
appropriate channels, as deployment will require some down-time.

### Upgrading an existing instance from Solr 8 to 9.10.1

1. Announce the downtime window.
2. Replace the core's config on the persistent volume. `ops/boot.sh` copies
   `/opt/config` with `cp -rn` (no-clobber), so an existing
   `/var/solr/data/<core>/conf` directory never receives new files. Move the
   old `conf` directory aside (including any `managed-schema` or
   `schema.xml.bak` Solr 8 left behind) before starting the new container so
   the new `solrconfig.xml` and `schema.xml` are picked up.
3. Plan a full reindex from the application for each environment. Lucene 9 can
   open indexes written by Solr 8, but any segment written by Solr 7 or older
   makes the core fail to load, and the `luceneMatchVersion` bump changes
   analysis behaviour. If a reindex is not possible for an environment, run an
   `optimize` on Solr 8 first so every segment is rewritten by 8.x, then upgrade.
4. Spellcheck indexes (`spell`, `spell_author`, `spell_subject`, `spell_title`)
   are rebuilt on the next `optimize` (`buildOnOptimize=true`).
5. If startup fails with `AccessControlException`, the Java Security Manager
   (enabled by default in Solr 9) is the cause. Setting
   `SOLR_SECURITY_MANAGER_ENABLED=false` is the escape hatch; nothing in this
   config set should need it.

### Stopping the app
 - Stop the solr service
 ```bash
 cam stop
 ```

 ### Using the solr image in another application

 Use the following fragment in the docker-compose.yml for the application.

 ```
 services:
  solr:
    image: yalelibraryit/dc-solr:${SOLR_TAG:-latest}
    ports:
      - '8983:8983'
    volumes:
      - solr:/var/solr
    env_file:
      - .env
    command: bash -c 'precreate-core ${SOLR_CORE} /opt/config; precreate-core ${SOLR_TEST_CORE} /opt/config; exec solr -f'

volumes:
  solr:
 ```

Note, two environment variables are required. Add these to the `.env` file.

``` 
SOLR_TEST_CORE=blacklight-test
SOLR_CORE=blacklight-development
```

