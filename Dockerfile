FROM debian

ARG commit=b181cea

RUN apt-get update && \
  apt-get install -y autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev git

RUN mkdir -p /opt/riscv/xuantie-gnu-toolchain
WORKDIR /opt/riscv/xuantie-gnu-toolchain

RUN git init && \
  git remote add origin https://github.com/T-head-Semi/xuantie-gnu-toolchain.git && \
  git fetch --depth=1 origin ${commit} && \
  git checkout FETCH_HEAD && \
  git submodule update --init --recursive --depth=1 && \
  ./configure --prefix=/opt/riscv --enable-multilib && \
  make -j$(nproc) && \
  make install && \
  rm -rf /opt/riscv/xuantie-gnu-toolchain

ENV PATH="/opt/riscv/bin:${PATH}"

RUN useradd -ms /bin/bash riscv
USER riscv
WORKDIR /home/riscv
