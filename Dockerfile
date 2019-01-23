FROM ubuntu:18.04
MAINTAINER Cody Xie <xiekedi@gmail.com>

RUN mkdir -p /opt/riscv-build
WORKDIR /opt/riscv-build
#RUN git clone --recursive https://github.com/riscv/riscv-tools.git
COPY ./riscv-tools ./riscv-tools

RUN apt-get update && apt-get install -y --no-install-recommends \
	autoconf \
	automake \
	autotools-dev \
	curl \
	libmpc-dev \
	libmpfr-dev \
	libgmp-dev \
	libusb-1.0-0-dev \
	gawk \
	build-essential \
	bison \
	flex \
	texinfo \
	gperf \
	libtool \
	patchutils \
	bc \
	zlib1g-dev \
	device-tree-compiler \
	pkg-config \
	libexpat-dev

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/riscv
ENV RISCV=/opt/riscv
ENV PATH=$RISCV/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/riscv/lib:$LD_LIBRARY_PATH

WORKDIR /opt/riscv-build/riscv-tools
RUN ./build.sh
RUN riscv64-unknown-elf-gcc -v

RUN rm -rf /opt/riscv-build

RUN mkdir -p /opt/riscv-projects
VOLUME /opt/riscv-projects
WORKDIR /opt/riscv-projects

