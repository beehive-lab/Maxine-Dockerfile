FROM ubuntu:18.04
LABEL maintainer="foivos.zakkak@manchester.ac.uk"

RUN apt-get update

RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y gdb
RUN apt-get install -y g++
RUN apt-get install -y python2.7
RUN apt-get install -y git

RUN apt-get install -y openjdk-8-jdk

RUN apt-get install -y zsh

ENV MAXINE_SRC=/maxine-src
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV MAXINE_HOME=$MAXINE_SRC/maxine
ENV DEFAULT_VM=maxine
ENV PATH=$PATH:$MAXINE_SRC/mx/:$MAXINE_HOME/com.oracle.max.vm.native/generated/linux/

# You will need to download and install SPECJVM2008 manually to the following directory
# ENV SPECJVM2008=$MAXINE_SRC/graal/lib/SPECJVM2008

WORKDIR $MAXINE_HOME