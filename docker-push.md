## Run a web application in Docker
- run
```
$ docker run -d -P training/webapp python app.py
$ docker ps -l
$ docker-machine ip
```
- check it on the web

## Creating our own images
### Updating and committing an image
```
$ docker run -t -i training/sinatra /bin/bash
# apt-get install -y ruby2.0-dev ruby2.0
# gem2.0 install json
$ docker commit -m "Added json gem" -a "Kate Smith" 0b2616b0e5a8 ouruser/sinatra:v2
$ docker images

// To use our new image 
$ docker run -t -i ouruser/sinatra:v2 /bin/bash
```

### Building an image from a Dockerfile
```
$ mkdir sinatra
$ cd sinatra
$ cat >> Dockerfile << EOF
# This is a comment
FROM ubuntu:14.04
MAINTAINER Kate Smith <ksmith@example.com>
RUN apt-get update && apt-get install -y ruby ruby-dev
RUN gem install sinatra
EOF
$ docker build -t ouruser/sinatra:v2 .

// To use our new image 
$ docker run -t -i ouruser/sinatra:v2 /bin/bash
```

### Push an image to Docker Hub
```
$ docker push ouruser/sinatra

//Check size of images and containers
$ docker history ouruser/sinatra
```

## (Case Study) Create & Running docker web app
- Building an image from a Dockerfile
```
git clone https://github.com/docker-training/webapp
cd webapp
docker build -t cgshome2/python-webapp .
```
- Running & Testing app
```
docker run -d -P cgshome2/python-webapp python app.py
docker ps -l
```

- Push an image to Docker Hub
```
docker push cgshome2/python-webapp
```

## Reference
- https://docs.docker.com/engine/tutorials/usingdocker/
