FROM ubuntu:18.04 AS builder
MAINTAINER Cody Xie <xiekedi@gmail.com>

RUN mkdir -p /opt/riscv-build
WORKDIR /opt/riscv-build
#RUN git clone --recursive https://github.com/riscv/riscv-tools.git
COPY ./riscv-tools ./riscv-tools

RUN apt-get update && apt-get install -y \
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
	libexpat-dev \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/riscv
RUN export RISCV=/opt/riscv
RUN export PATH=$RISCV/bin:$PATH

WORKDIR /opt/riscv-build/riscv-tools
ENV RISCV=/opt/riscv
RUN ./build.sh
RUN riscv64-unknown-elf-gcc -v

# The final image for the riscv tools
FROM alpine:latest

COPY --from=builder /opt/riscv /opt/riscv
RUN export RISCV=/opt/riscv
RUN export PATH=$RISCV/bin:$PATH
RUN mkdir -p /opt/riscv-projects
VOLUME /opt/riscv-projects
WORKDIR /opt/riscv-projects

