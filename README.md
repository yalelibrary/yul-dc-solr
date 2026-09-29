# yul-dc-solr
Solr for Digital Collections

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

