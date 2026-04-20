FROM python:3.6
COPY ./src/udpipe_2/requirements.txt /tmp/requirements.txt
COPY ./src/udpipe_2/wembedding_service/requirements.txt /tmp/requirements2.txt
WORKDIR /tmp/
RUN pip install -r requirements.txt
RUN pip install -r requirements2.txt
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb
RUN apt update
RUN apt install -y --no-install-recommends cuda-libraries-11-2 libcudnn8
RUN echo "/usr/local/cuda-11.2/targets/x86_64-linux/lib" > /etc/ld.so.conf.d/cuda.conf
RUN ldconfig
EXPOSE 8001
WORKDIR /veld/code/

