FROM ubuntu:16.04

ARG UID
ARG GID
ENV UID ${UID:-1000}
ENV GID ${GID:-1000}

RUN apt-get update && apt-get install -y \
    bc \
    curl \
    sudo

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get update && apt-get install -y \
    ruby \
    python \
    python3 \
    nodejs

# We need two users. Guardian is the one that has r/w access to the mounted directory
# while executor should only be able to read source file wihtout having write access anywhere
RUN groupadd -g $GID guardian
RUN useradd -u $UID -g $GID guardian && adduser guardian sudo
RUN useradd executor
RUN echo "guardian ALL=(executor) NOPASSWD: ALL" >> /etc/sudoers

USER guardian
