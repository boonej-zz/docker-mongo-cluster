#!/bin/bash

MONGOD=/usr/bin/mongod
MONGO=/usr/bin/mongo
LOG_PATH=/var/log/mongod/mongod.log
PORT=27017

check_status()
{
  SERVER=$1
  $MONGO --host $SERVER --eval db
  while [ "$?" -ne 0 ]
  do
    echo "Waiting for server too come up."
    sleep 10
    $MONGO --host $SERVER --eval db
  done
}

configure_replication ()
{
  $MONGO --host 127.0.0.1:${PORT} --eval 'rs.initiate()'
  check_status ${S1}:${PORT}
  $MONGO --host 127.0.0.1:${PORT} --eval "rs.add(\"${S1}:${PORT}\")"
  check_status $S2:${PORT}
  $MONGO --host 127.0.0.1:${PORT} --eval "rs.add(\"${S2}:${PORT}\")"
}

build_replica_set ()
{
  PORT=27018
  mv /data/restore /data/db
  $MONGOD --fork --shardsvr --replSet $RS_NAME --logpath \
    $LOG_PATH 
  if [ $STATE = 'primary' ]
  then
    configure_replication
  fi
}

build_config_set ()
{
  PORT=27019
  rm -r /data/restore
  mkdir /data/configdb
  $MONGOD --fork --replSet $RS_NAME --configsvr \
    --logpath $LOG_PATH
  if [ $STATE = 'primary' ]
  then
    configure_replication
  fi
}

build_router ()
{
  PORT=27017
  LOG_PATH=/var/log/mongos.log
  check_status mdb-cs1:27019
  check_status mdb-cs2:27019
  check_status mdb-cs3:27019
  /usr/bin/mongos --configdb cs/mdb-cs1,mdb-cs2,mdb-cs3 \
    --logpath $LOG_PATH --fork
  SHARD1=rs1/mdb-s1r1:27018,mdb-s1r2:27018,mdb-s1r3:27018
  SHARD2=rs2/mdb-s2r1:27018,mdb-s2r2:27018,mdb-s2r3:27018
  check_status $SHARD1
  $MONGO --eval "sh.addShard(\"${SHARD1}\")"
  check_status $SHARD2
  $MONGO --eval "sh.addShard(\"${SHARD2}\")"
}

if [ $SHARD_ENV = 'replicaset' ]
then
  build_replica_set
fi

if [ $SHARD_ENV = 'configset' ]
then
  build_config_set
fi

if [ $SHARD_ENV = 'router' ]
then
  build_router
fi

tailf $LOG_PATH
