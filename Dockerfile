FROM ubuntu:16.04
MAINTAINER "Foivos Zakkak" <foivos.zakkak@manchester.ac.uk>

RUN apt-get update
RUN apt-get install -y zsh
RUN apt-get install -y mercurial

# Download and build jdk7u131-b00
RUN hg clone http://hg.openjdk.java.net/jdk7u/jdk7u/ /opt/jdk7u
RUN cd /opt/jdk7u && hg up jdk7u131-b00
RUN cd /opt/jdk7u && sh ./make/scripts/hgforest.sh clone
RUN cd /opt/jdk7u && sh ./make/scripts/hgforest.sh up jdk7u131-b00

# jdk7u build dependencies
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get build-dep -y openjdk-9-jdk
RUN apt-get install -y openjdk-7-jdk

ENV ALT_BOOTDIR=/usr/lib/jvm/java-7-openjdk-amd64/
ENV ALT_JDK_IMPORT_PATH=$ALT_BOOTDIR

RUN cd /opt/jdk7u && make debug_build

ENV JAVA_HOME=/opt/jdk7u/build/linux-amd64-debug/

ENV MAXINE_SRC=/maxine-src
ENV MAXINE_HOME=$MAXINE_SRC/maxine
ENV PATH=$PATH:$MAXINE_SRC/graal/mxtool/:$MAXINE_HOME/com.oracle.max.vm.native/generated/linux/

# You will need to download and install SPECJVM2008 manually to the following directory
ENV SPECJVM2008=$MAXINE_SRC/graal/lib/SPECJVM2008

WORKDIR $MAXINE_HOME