#!/bin/bash

set -eux

curl -s -X PUT -H Content-type:application/json \
-d '{"comment":"Hello there","location":"s3a://mybucket/mydb","properties":{"a":"b"}}' \
http://localhost:50111/templeton/v1/ddl/database/mydb1?user.name=ilya

# curl -s -X PUT -H Content-type:application/json -d '{
#  "comment": "Best table made today",
#  "columns": [
#    { "name": "id", "type": "string" },
#    { "name": "fn", "type": "string" },
#    { "name": "ln", "type": "string" }
#   ],
# "format": { "storedAs": "TEXTFILE" },
# "location": "s3a://mybucket/mydata/" }' \
# 'http://localhost:50111/templeton/v1/ddl/database/mydb/table/test_table_000?user.name=ilya'
