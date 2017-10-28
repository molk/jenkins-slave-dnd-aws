# Description

A Docker image running a [Jenkins JNLP Slave](https://wiki.jenkins.io/display/JENKINS/Distributed+builds) with Docker-in-Docker and [AWS CLI](https://aws.amazon.com/cli/) support.

It extends the official DinD image from [docker-library/docker](https://github.com/docker-library/docker) adding the [jenkins-slave](jenkins-slave) script and the required packages to use it in the AWS Cloud.

Current parent is `docker:17.03.2-ce-dind` (see [docker:17.06](https://github.com/docker-library/docker/tree/168a6d227d021c6d38c3986b7c668702ec172fa7/17.06/dind) for details).

The size of the build image is approximately `350 MB`.


## Additional Packages

As this image is based on [Alpine Linux](https://hub.docker.com/_/alpine/) the followin additional packages have to be installed:

* openjdk8
* maven
* awscli
* python / pip
* git
* curl
* openssh
* sudo


## Jenkins JNLP Slave

The Jenkins remoting library (aka _JNLP Slave_ or `slave.jar`) is pulled from the [Jenkins CI Repos](http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/).


## Docker in Docker

The Docker API access (aka _Docker in Docker_ as the Jenkins slave is running in a Docker Container) for builds creating Docker artefacts is realized via the [`/var/run/docker.sock` unix socket](https://medium.com/lucjuggery/about-var-run-docker-sock-3bfd276e12fd).

Hence a `dockerd` is started making the Docker API available for Jenkins builds (see [jenkins-slave](jenkins-slave) script).