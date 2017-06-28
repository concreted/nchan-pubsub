FROM ubuntu:14.04

RUN mkdir -p /usr/download
WORKDIR /usr/download

RUN apt-get update
RUN apt-get -y install wget
RUN wget 'https://nchan.io/download/nginx-common.ubuntu.deb'
RUN wget 'https://nchan.io/download/nginx-extras.ubuntu.deb'
RUN dpkg -i nginx-common.ubuntu.deb
# ignore install errors because apt-get -f will install missing deps
RUN dpkg -i nginx-extras.ubuntu.deb ; exit 0
RUN apt-get -f -y install

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
