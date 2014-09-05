####
# Docker base pipeline
# use this as boilerplate to create your own pipeline
#
# Version 0.42
####

# use the ubuntu:precise base image provided by dotCloud
FROM ubuntu:precise

MAINTAINER Name asczyrba@cebitec.uni-bielefeld.de

# install the required packages to the base ubuntu installation
# e.g. RUN apt-get install -y -f bc

RUN apt-get update
RUN apt-get install -y -f perl-modules
RUN apt-get install -y -f openjdk-7-jre


# create directories where the host file system can be mounted
# required!
RUN mkdir -p /vol
# required!
RUN mkdir /vol/tmp

# copy the required scripts that run the pipeline from your machine to the
# Docker image and make them executable
# required!
ADD ./kraken/ /vol/kraken/
RUN chmod 755 /vol/kraken/*
ADD ./scripts/ /vol/scripts/
#ADD ./init_pipeline.sh /
#RUN chmod 755 /init_pipeline.sh

# set entrypoint to initialize the pipeline
#ENTRYPOINT ["/vol/scripts/init_pipeline.sh"]
