FROM --platform=linux/amd64 debian:stable-20241111-slim
RUN apt-get update
RUN apt-get -y install build-essential
COPY ./src/udpipe_1/src/ /opt/udpipe/
WORKDIR /opt/udpipe/
RUN make 
RUN ln -s /opt/udpipe/udpipe /usr/local/bin/udpipe
COPY ./src/main/train.sh /veld/code/train.sh
WORKDIR /veld/code/

