# escape=\

FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -y wget
RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y gdb
RUN apt-get install -y g++
RUN apt-get install -y python2.7

# install openjdk7
ENV ARCH=amd64
ENV VERSION=7u151-2.6.11-3
ENV JAVA=openjdk-7
ENV BASE_URL=http://snapshot.debian.org/archive/debian/20171124T100538Z

WORKDIR /tmp

RUN for package in jre jre-headless jdk dbg; do \
wget -nv ${BASE_URL}/pool/main/o/${JAVA}/${JAVA}-${package}_${VERSION}_${ARCH}.deb; \
done

# openjdk dependencies
RUN wget -nv http://ftp.uk.debian.org/debian/pool/main/libj/libjpeg-turbo/libjpeg62-turbo_1.5.1-2_${ARCH}.deb
RUN wget -nv http://ftp.uk.debian.org/debian/pool/main/f/fontconfig/libfontconfig1_2.13.0-5_${ARCH}.deb
RUN wget -nv http://ftp.uk.debian.org/debian/pool/main/f/fontconfig/fontconfig-config_2.13.0-5_all.deb

RUN dpkg -i ${JAVA}-* libjpeg62-turbo_1* libfontconfig1* fontconfig-config* || \
apt install -yf

# remove install deps
RUN apt-get remove -y --purge wget

ENV HOME /home/developer
ENV MAXINE_SRC=$HOME/maxine-vm
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
ENV MAXINE_HOME=$MAXINE_SRC/maxine
ENV PATH=$PATH:$MAXINE_SRC/graal/mxtool/:$MAXINE_HOME/com.oracle.max.vm.native/generated/linux/

# Replace 1000 with your user / group id
# Required for sharing X11 socket
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/developer

USER developer
WORKDIR $MAXINE_HOME
