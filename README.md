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
  ``` bash
  docker-compose build
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
