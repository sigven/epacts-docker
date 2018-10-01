############################################################
# Dockerfile to build EPACTS

FROM ubuntu:18.04

USER root

RUN apt-get update && apt-get install -y build-essential apt-utils gnuplot5 git zlib1g-dev ghostscript groff
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && apt-get install -y gcc-5 g++-5 automake
RUN apt-get update && apt-get install -y --no-install-recommends \
    r-base-core \
    r-recommended \
 		r-base

RUN apt-get update && apt-get install -y libtool

RUN mkdir ~/.R && chmod 777 ~/.R
ADD Makevars ~/.R/
ENV R_HOME=~/.R

RUN ln -s /usr/bin/gcc-5 /usr/local/bin/gcc
RUN ln -s /usr/bin/g++-5 /usr/local/bin/g++

ENV PATH=/usr/local/bin:$PATH

RUN git clone https://github.com/statgen/EPACTS.git
WORKDIR EPACTS
RUN autoreconf -vfi
RUN CC="gcc-5" CXX="g++-5" ./configure --prefix /usr/local/bin
RUN make -j 1
RUN make -j 1 install

