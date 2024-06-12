FROM debian:latest
RUN apt-get update
RUN apt-get -y install \
#  gcc \
#  gcc-aarch64-linux-gnu \
  clang \
  build-essential \
  curl
COPY ./src/udpipe/src/ /opt/udpipe/
WORKDIR /opt/udpipe/
RUN make 
RUN ln -s /opt/udpipe/udpipe /usr/local/bin/udpipe
COPY ./src/main/train.sh /veld/code/train.sh
WORKDIR /veld/code/

