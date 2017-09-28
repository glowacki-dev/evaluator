FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y ruby
RUN apt-get install -y python
RUN apt-get install -y python3
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
