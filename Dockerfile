FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    bc \
    curl

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get update && apt-get install -y \
    ruby \
    python \
    python3 \
    nodejs
