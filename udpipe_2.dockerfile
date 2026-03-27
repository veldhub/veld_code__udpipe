FROM python:3.6
COPY ./src/udpipe_2/requirements.txt /tmp/requirements.txt
COPY ./src/udpipe_2/wembedding_service/requirements.txt /tmp/requirements2.txt
WORKDIR /tmp/
RUN pip install -r requirements.txt
RUN pip install -r requirements2.txt
EXPOSE 8001
WORKDIR /veld/code/

