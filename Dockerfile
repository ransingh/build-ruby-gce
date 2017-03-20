# DOCKER-VERSION 1.6.2

FROM ubuntu:14.04

MAINTAINER Ranbir Singh "ransingh57@yahoo.com"

RUN apt-get -y update

# install essentials
RUN apt-get -y install build-essential curl
RUN apt-get install -y -q git
RUN apt-get install -y --force-yes zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libxml2-dev \
    libxslt-dev \
    libpq-dev

# Install postgres client (becoz i have not figured out how to get Sequel to create and drop database
# without making any connection to a database)
#RUN deb http://apt.postgresql.org/pub/repos/apt trsuty-pgdg main
RUN apt-get -y install postgresql-9.3
RUN apt-get -y install postgresql-client-9.3

# Install Docker from Docker Inc. repositories.
RUN echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/dockerlist
RUN apt-get -y install docker.io

# # Insatll docker pre-requisites
# RUN apt-get -y install apt-transport-https ca-certificates
# RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# RUN echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/dockerlist
#
# RUN apt-get -y install linux-image-extra-$(uname -r)
# RUN apt-get -y install apparmor
# RUN apt-get -y install docker-engine

########################################
# Install nodejs, npm and global friends
########################################
RUN apt-get -y install nodejs-legacy
RUN apt-get -y install npm

RUN npm install npm -g
# # install runtime dependencies
# RUN npm install bower@1.4.1   #-verbose
#
# # install tools for building
# RUN npm install grunt@0.4.5   #-verbose
# RUN npm install grunt-cli

# show the versions
RUN node -v
RUN npm -v

# necessary for running phantomJS
RUN apt-get -y install libfontconfig
RUN apt-get -y install libfreetype6

# install aws cli for deploying
RUN ["curl", "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip","-o", "awscli-bundle.zip"]
RUN ["sudo", "apt-get", "install", "unzip"]
RUN ["unzip","awscli-bundle.zip"]
#RUN ["./awscli-bundle/install", "-b", "~/bin/aws"]
RUN ["sudo", "./awscli-bundle/install", "-i", "/usr/local/aws", "-b","/usr/local/bin/aws"]

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh

# install ruby-build
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

ENV RBENV_ROOT /usr/local/rbenv

ENV PATH "$RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# does not work
# PATH is set to
# $RBENV_ROOT/shims:$RBENV_ROOT/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# install ruby
RUN rbenv install 2.3.0

# set ruby 2.3.0 as system ruby
RUN ["rbenv","global","2.3.0"]

# install bundler
RUN ["gem", "install", "bundler"]

# add new user
RUN ["adduser", "--disabled-password", "--gecos", "Tracktask", "tracktask"]
RUN ["adduser", "tracktask", "sudo" ]
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#RUN ["chown", "root:docker", "/var/run/docker.sock"]
#VOLUME ['/var/run/docker.sock']
#RUN usermod -a -G docker tracktask
USER tracktask
#WORKDIR /home/tracktask
