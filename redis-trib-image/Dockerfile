FROM ubuntu
LABEL maintainer "weifeilong"

RUN apt-get update \
    && apt-get install -y vim wget python2.7 python-pip redis-tools dnsutils \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && pip install redis-trib
