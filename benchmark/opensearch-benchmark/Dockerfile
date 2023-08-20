FROM python:3.11-alpine

RUN apk add --update --no-cache git build-base linux-headers python3-dev \
&& python3 -m pip install --no-cache-dir --upgrade pip \
&& python3 -m pip install -U setuptools \
&& python3 -m pip install --no-cache-dir opensearch-benchmark==1.0.0

#COPY rally.ini /root/.rally/
