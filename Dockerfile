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
RUN apt-get install -y tmux
RUN apt-get install -y screen

# Cross-ISA support
RUN apt-get install -y lsof
RUN apt-get install -y gdb-multiarch

# For AArch64 and ARMv7 support
RUN apt-get install -y qemu-system-arm
RUN apt-get install -y gcc-aarch64-linux-gnu
RUN apt-get install -y gcc-arm-none-eabi

# For RISC-V support
RUN apt-get install gcc-riscv64-linux-gnu
# gdb
# qemu

# For perf support
RUN apt-get install -y linux-tools-generic

ENV MAXINE_SRC=/maxine-src
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV MAXINE_HOME=$MAXINE_SRC/maxine
ENV DEFAULT_VM=maxine
ENV PATH=$PATH:$MAXINE_SRC/mx/:$MAXINE_HOME/com.oracle.max.vm.native/generated/linux/

# You will need to download and install SPECJVM2008 manually to the following directory
# ENV SPECJVM2008=$MAXINE_SRC/graal/lib/SPECJVM2008

WORKDIR $MAXINE_HOME

# setup user management as shown in:
# https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
RUN apt-get install -y gosu
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
