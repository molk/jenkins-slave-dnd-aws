FROM docker:17.03.2-ce-dind

MAINTAINER Marcus Olk <m@rcus-olk.net>

# install required packages
RUN apk --update add \
    curl \
    git \
    openjdk8 \
    maven \
    sudo \
    openssh \
    python py-pip ca-certificates groff

# upgrade pip
RUN pip install --upgrade pip setuptools

# install aws cli
RUN pip install awscli

ENV JENKINS_HOME /home/jenkins
ENV JENKINS_REMOTNG_VERSION 3.9

ENV JENKINS_GROUP 1000
ENV DOCKER_GROUP  497

ENV DOCKER_HOST unix:///var/run/docker.sock

# add jenkins user and allow jenkins user to run as root
RUN    addgroup -g $DOCKER_GROUP  -S docker \
    && addgroup -g $JENKINS_GROUP -S jenkins \
    && adduser -G jenkins -D -h $JENKINS_HOME -s /bin/bash -u $JENKINS_GROUP jenkins \
    && adduser jenkins docker \
    && passwd -u jenkins \
    && chmod a+rwx $JENKINS_HOME \
    && echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/10-jenkins \
    && chmod 440 /etc/sudoers.d/10-jenkins 

# compatibility with CloudBees 'AWS CLI Plugin' which expects pip to be installed as user
RUN mkdir -p /home/jenkins/.local/bin/ \
  && ln -s /usr/bin/pip /home/jenkins/.local/bin/pip \
  && chown -R jenkins:jenkins /home/jenkins/.local

COPY jenkins-slave /usr/local/bin/jenkins-slave

# Install Jenkins Remoting agent
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTNG_VERSION/remoting-$JENKINS_REMOTNG_VERSION.jar \
    && chmod 755 /usr/share/jenkins /usr/local/bin/jenkins-slave \
    && chmod 644 /usr/share/jenkins/slave.jar

VOLUME $JENKINS_HOME
WORKDIR $JENKINS_HOME

USER jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
