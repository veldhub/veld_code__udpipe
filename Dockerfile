FROM ubuntu:18.04
RUN apt-get update
RUN apt-get -y install \
  gcc=4:7.4.0-1ubuntu2.3 \
  clang=1:6.0-41~exp5~ubuntu1 \
  build-essential=12.4ubuntu1 \
  wget=1.19.4-1ubuntu2.2 \
  python=2.7.15~rc1-1
COPY ./src/udpipe/src/ /opt/udpipe/
WORKDIR /opt/udpipe/
RUN make 
RUN ln -s /opt/udpipe/udpipe /usr/local/bin/udpipe
WORKDIR /veld/executable/
