# Sharded Mongo Cluster in Docker

The idea behind this project is to create an easy, portable way to simulate 
a sharded mongodb cluster in Docker to ease development in a local development
environment.

## Status

As is, the project will generate a sharded cluster with 2 shards, a config 
replica set, and a mongos router. A database will be copied to a shard from
local data but all sharding must be performed manually.

## Usage

If you wish to copy a database into the cluster, copy all files into the 
mongo-base/data folder.

```
docker-compose up
```

## TODO
- Add a method to choose a database to shard
- Add a method to configure sharded collections
- Add a method to generate a variable number of shards
