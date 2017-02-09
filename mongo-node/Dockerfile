FROM mongo-base
MAINTAINER Jonathan Boone <jeboone@gmail.com>

ADD run.sh /root/run.sh
RUN mkdir -p /var/log/mongod && \
  touch /var/log/mongod/mongod.log
RUN mkdir -p /data/
ADD data /data/restore

EXPOSE 27017
EXPOSE 27018
EXPOSE 27019

CMD ["/root/run.sh"]
