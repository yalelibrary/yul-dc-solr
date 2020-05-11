# yul-dc-solr
Solr for Digital Collections

# Prerequisites
- Download [Docker Desktop](https://www.docker.com/products/docker-desktop) and log in


# Docker Development Setup
### If this is your first time working in this repo, build the base service (dependencies, etc. that don't change)
  ``` bash
  docker-compose build
  ```

### If this is your first time working in this repo or the Dockerfile has been updated you will need to (re)build your services

- Push to the git repository
- Set the environment variable for the tag to the git commit
  ```bash
  export SOLR_TAG=$(git rev-parse --short HEAD)
  ```
& build your image based on the docker-compose file
  ``` bash
  docker-compose build
  ```
- If appropriate, push the tagged image to the Dockerhub repository
  ```bash
  docker-compose push
  ```

### Starting the app
- Start the solr service
  ``` bash
  docker-compose up
  ```

  - Access the solr instance at `http://localhost:8983`

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
    command: bash -c 'precreate-core ${SOLR_CORE} /opt/config; precreate-core ${SOLR_TEST_CORE} /opt/config; exec solr -f'

volumes:
  solr:
 ```

Note, two environment variables are required. Add these to the `.env` file.

``` 
SOLR_TEST_CORE=blacklight-test
SOLR_CORE=blacklight-development
```

