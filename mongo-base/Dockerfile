FROM ubuntu:16.04 
MAINTAINER Jonathan Boone <jeboone@gmail.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
  --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo \
  "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu " \
  "xenial/mongodb-org/3.4 multiverse" | \
  tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN apt-get -y update && apt-get install -y \
  mongodb-org
RUN mkdir -p /data/db
EXPOSE 27017
EXPOSE 27018
EXPOSE 27019
CMD ["mongod"]  
