#!/bin/bash

mkdir databend && cd databend
curl -LJO 'https://github.com/datafuselabs/databend/releases/download/v0.9.20-nightly/databend-v0.9.20-nightly-x86_64-unknown-linux-musl.tar.gz'
tar xzvf 'databend-v0.9.20-nightly-x86_64-unknown-linux-musl.tar.gz'
 
cat > config.toml << CONF
[storage]
type = "fs"

[storage.fs]
data_path = "./_data"

[meta]
embedded_dir = "./.databend/meta_embedded"
CONF

# databend starts with embedded meta service
./bin/databend-query -c config.toml > query.log 2>&1 &

# Load the data
# Docs: https://databend.rs/doc/learn/analyze-hits-dataset-with-databend
curl 'http://default@localhost:8124/' --data-binary @create.sql

wget --continue 'https://datasets.clickhouse.com/hits_compatible/hits.tsv.gz'
gzip -d hits.tsv.gz

time curl -XPUT 'http://root:@127.0.0.1:8000/v1/streaming_load' -H 'insert_sql: insert into hits FILE_FORMAT = (type = TSV)' -F 'upload=@"./hits.tsv"'

[ec2-user@ip-172-31-21-28 ~]$ time curl -XPUT 'http://root:@127.0.0.1:8000/v1/streaming_load' -H 'insert_sql: insert into hits FILE_FORMAT = (type = TSV)' -F 'upload=@"./hits.tsv"'

# {"id":"89383f95-33e5-4181-9019-bc347918d806","state":"SUCCESS","stats":{"rows":99997497,"bytes":74807831229},"error":null,"files":["hits.tsv"]}
# real    6m3.734s
# user    0m2.145s
# sys     0m37.053s

## check data
curl 'http://default@localhost:8124/' --data-binary "select count() from hits"

du -bcs _data
# 20924841245     _data

./run.sh 2>&1 | tee log.txt
