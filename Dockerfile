FROM ubuntu:14.04

RUN mkdir -p /usr/download
WORKDIR /usr/download

# Install Nginx + Nchan
RUN apt-get update
RUN apt-get -y install wget
RUN wget 'https://nchan.io/download/nginx-common.ubuntu.deb'
RUN wget 'https://nchan.io/download/nginx-extras.ubuntu.deb'
RUN dpkg -i nginx-common.ubuntu.deb
# ignore install errors because apt-get -f will install missing deps
RUN dpkg -i nginx-extras.ubuntu.deb ; exit 0
RUN apt-get -f -y install

# Install Redis
RUN mkdir -p /usr/src
WORKDIR /usr/src
RUN apt-get update
RUN apt-get -y install build-essential
RUN wget 'http://download.redis.io/redis-stable.tar.gz'
RUN tar -xzf redis-stable.tar.gz
WORKDIR /usr/src/redis-stable
RUN make

# Deps for Redis Cluster
RUN apt-get -y install ruby-full telnet
RUN gem install redis
RUN chmod +x /usr/src/redis-stable/utils/create-cluster/create-cluster

# Nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

WORKDIR /usr/src/redis-stable/utils/create-cluster
CMD ./create-cluster start && yes yes | ./create-cluster create && nginx
# CMD nginx
