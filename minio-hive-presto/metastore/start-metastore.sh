#!/usr/bin/env sh

bin/schematool -dbType postgres -initSchema && bin/hive --service metastore
