FROM ubuntu:14.04
MAINTAINER "Foivos Zakkak" <foivos.zakkak@manchester.ac.uk>

# Add saucy sources for java 7 u25
RUN echo "\ndeb http://old-releases.ubuntu.com/ubuntu/ saucy main" >> /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y gdb
RUN apt-get install -y g++
RUN apt-get install -y mercurial

RUN apt-get install -y openjdk-7-jre-lib=7u25-2.3.12-4ubuntu3 openjdk-7-jre-headless=7u25-2.3.12-4ubuntu3 openjdk-7-jre=7u25-2.3.12-4ubuntu3 openjdk-7-jdk=7u25-2.3.12-4ubuntu3

RUN apt-get install -y zsh

ENV MAXINE_SRC=/maxine-src
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
ENV MAXINE_HOME=$MAXINE_SRC/maxine
ENV PATH=$PATH:$MAXINE_SRC/graal/mxtool/:$MAXINE_HOME/com.oracle.max.vm.native/generated/linux/

# You will need to download and install SPECJVM2008 manually to the following directory
ENV SPECJVM2008=$MAXINE_SRC/graal/lib/SPECJVM2008

WORKDIR $MAXINE_HOME