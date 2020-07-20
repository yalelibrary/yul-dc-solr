# yul-dc-solr
Solr for Digital Collections

# Prerequisites
- Download [Docker Desktop](https://www.docker.com/products/docker-desktop) and log in


# Docker Development Setup
### Building locally in development
  ``` bash
  docker-compose build
  ```

### Starting the app
- Start the solr service
  ``` bash
  docker-compose up
  ```

  - Access the solr instance at `http://localhost:8983`

### Making a new release

1. Decide on a new version number. We use [semantic versioning](https://semver.org/).
1. Look through all merged PRs since the last release and write release notes as
a list of Features, Bug Fixes, and Other.
1. Once CI has finished and passed on the most recent merge to the default branch,
in the github web UI go to "Releases" and tag a new release with the version number
you chose; release tags that match the pattern `v10.2.3` (the letter v followed by
three numbers separated by dots) will be automatically built and tagged.
1. Once the publish-github-release job has finished in circleci, update `yul-dc-camerata`
with the new version of the solr image; submit a PR.

### Deployment
Since Solr is a stateful application, announce deployment in the
appropriate channels, as deployment will require some down-time, including
restarting the blacklight and management apps.

### Stopping the app
 - Stop the solr service
 ```bash
 docker-compose down
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
      - solr:/opt/solr/server/solr/mycores
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
