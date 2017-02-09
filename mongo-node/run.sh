#!/bin/bash

MONGOD=/usr/bin/mongod
MONGO=/usr/bin/mongo
LOG_PATH=/var/log/mongod/mongod.log

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

build_replica_set ()
{
  $MONGOD --fork --replSet $RS_NAME --logpath \
    $LOG_PATH 
  if [ $STATE = 'primary' ]
  then
    $MONGO --eval 'rs.initiate()'
    check_status $S1
    $MONGO --eval "rs.add(\"${S1}\")"
    check_status $S2
    $MONGO --eval "rs.add(\"${S2}\")"
  fi
}

if [ $SHARD_ENV = 'replicaset' ]
then
  build_replica_set
fi

tailf $LOG_PATH
