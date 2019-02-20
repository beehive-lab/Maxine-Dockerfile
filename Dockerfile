FROM ubuntu:18.04
LABEL maintainer="foivos.zakkak@manchester.ac.uk"
LABEL name="beehivelab/maxine-dev"
LABEL version="0.1"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    make gcc gdb g++ python python2.7 git \
    openjdk-8-jdk \
    screen \
    && apt-get clean

# Cross-ISA support
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    lsof gdb-multiarch \
    && apt-get clean

# For AArch64 and ARMv7 support
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    qemu-system-arm gcc-aarch64-linux-gnu gcc-arm-none-eabi \
    && apt-get clean

# For RISC-V support
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc-riscv64-linux-gnu \
    && apt-get clean
# qemu
RUN apt-get update && \
    apt-get install -y --no-install-recommends pkg-config \
    libglib2.0-dev libpixman-1-dev flex bison \
    && apt-get clean
RUN git clone --depth 1 --branch riscv-for-master-3.1-rc2 --recursive https://github.com/riscv/riscv-qemu.git /tmp/riscv/riscv-qemu \
    && cd /tmp/riscv/riscv-qemu \
    && ./configure --target-list=riscv64-softmmu,riscv32-softmmu,riscv64-linux-user,riscv32-linux-user --prefix=/opt/riscv \
    && make -j$(nproc) && make install && rm -rf /tmp/riscv/riscv-qemu
# gdb
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget texinfo \
    && apt-get clean
RUN cd /tmp/riscv/ && \
    wget https://ftp.gnu.org/gnu/gdb/gdb-8.2.1.tar.xz \
    && tar xf gdb-8.2.1.tar.xz \
    && cd /tmp/riscv/gdb-8.2.1 \
    && ./configure --target=riscv64-elf --disable-multilib --prefix=/opt/riscv \
    && make -j$(nproc) && make install && cd ~ && rm -rf /tmp/riscv

# For perf support
RUN apt-get update && \
    apt-get install -y --no-install-recommends linux-tools-generic \
    && apt-get clean

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
RUN apt-get update && \
    apt-get install -y --no-install-recommends gosu \
    && apt-get clean
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
