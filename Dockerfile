FROM ubuntu:18.04
LABEL maintainer="foivos.zakkak@manchester.ac.uk"

RUN apt-get update

RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y gdb
RUN apt-get install -y g++
RUN apt-get install -y python python2.7
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
RUN apt-get install -y gcc-riscv64-linux-gnu
# qemu
RUN apt-get install -y pkg-config
RUN apt-get install -y libglib2.0-dev
RUN apt-get install -y libpixman-1-dev
RUN apt-get install -y flex
RUN apt-get install -y bison
RUN git clone --depth 1 --branch riscv-for-master-3.1-rc2 --recursive https://github.com/riscv/riscv-qemu.git /tmp/riscv/riscv-qemu
WORKDIR /tmp/riscv/riscv-qemu
RUN ./configure --target-list=riscv64-softmmu,riscv32-softmmu,riscv64-linux-user,riscv32-linux-user --prefix=/opt/riscv
RUN make -j$(nproc)
RUN make install
# gdb
RUN apt-get install -y wget
RUN apt-get install -y texinfo
WORKDIR /tmp/riscv/riscv-gdb
RUN wget https://ftp.gnu.org/gnu/gdb/gdb-8.2.1.tar.xz
RUN tar xf gdb-8.2.1.tar.xz
WORKDIR /tmp/riscv/riscv-gdb/gdb-8.2.1
RUN ./configure --target=riscv64-elf --disable-multilib --prefix=/opt/riscv
RUN make -j$(nproc)
RUN make install
RUN rm -rf /tmp/riscv
WORKDIR /tmp

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
