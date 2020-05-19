FROM ubuntu:xenial
MAINTAINER Harvard FAS Research Computing "rchelp@rc.fas.harvard.edu"

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:rael-gc/rvm && \
    apt-get update

RUN apt-get install -y rvm build-essential vim git tig && \
    rm -rf /var/lib/apt/lists/*

RUN /bin/bash --login -c 'rvm use 1.9.3 --install --binary --fuzzy && \
    gem install bundler -v 1.17.3'

RUN /bin/bash --login -c 'rvm use 2.0.0 --install --binary --fuzzy && \
    gem install bundler -v 1.17.3'

RUN /bin/bash --login -c 'rvm use 2.1.7 --install --binary --fuzzy && \
    gem install bundler -v 1.17.3'
