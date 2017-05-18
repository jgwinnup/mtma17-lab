#
# Docker File for MTMA17 labs
#

FROM ubuntu:16.04
MAINTAINER Jeremy Gwinnup, Air Force Research Laboratory <jeremy.gwinnup.1@us.af.mil>

RUN apt-get update && apt-get install -q -y \
	unzip \
	make \
	cmake \
	g++-4.8 \
	wget \
	git \
	emacs \
	bzip2 \
	autotools-dev \
	automake \
	libtool \
	zlib1g-dev \
	libbz2-dev \
	libboost-all-dev \
	libxmlrpc-core-c3-dev \
	libxmlrpc-c++8-dev \
	libcmph-dev \
	libboost-all-dev \
	libgoogle-perftools-dev \
	python-numpy \
	python-pip \
	luarocks

#python fun
RUN pip install --upgrade pip

#Theano
RUN pip install Theano

#build moses
RUN mkdir -p /home/build/moses
WORKDIR /home/build
RUN git clone https://github.com/moses-smt/mosesdecoder moses
WORKDIR /home/build/moses
#toolset=gcc-4.8 link=static
RUN ./bjam -j2 variant=release --with-xmlrpc-c=/usr --with-cmph=/usr --with-mm --with-probing-pt --with-boost=/usr install

#build amunmt
WORKDIR /home/build
RUN git clone https://github.com/amunmt/amunmt
RUN mkdir -p /home/build/amunmt/build
WORKDIR /home/build/amunmt/build
RUN cmake ..
RUN make

#torch
WORKDIR /home/build
RUN git clone https://github.com/torch/distro.git torch --recursive
WORKDIR /home/build/torch
#blah
RUN apt-get install sudo
RUN ./install-deps
RUN ./install.sh

#open NMT
WORKDIR /home/build
RUN git clone https://github.com/OpenNMT/OpenNMT

RUN luarocks install tds


#build marian
#hold for now
#WORKDIR /home/build
#RUN git clone https://github.com/amunmt/marian
#RUN mkdir -p /home/build/marian/build
#WORKDIR /home/build/marian/build
#RUN cmake ..
#RUN make cpu



#Make working dirs
RUN mkdir -p /home/mtma17
WORKDIR /home/mtma17

#Run a shell
RUN /bin/bash
