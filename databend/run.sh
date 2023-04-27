#!/bin/bash

database=$1
TRIES=3
QUERY_NUM=1

N=22
cat query.sql | while read query; do
    # [ -z "$HOST" ] && sync
    # [ -z "$HOST" ] && echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null

    echo -n "["
    for i in $(seq 1 $TRIES); do
        RES=$(bendsql --database ${database} --time --query "${query}" --output null 2>&1 ||:)
        [[ "$?" == "0" ]] && echo -n "${RES}" || echo -n "null"
        [[ "$i" != $TRIES ]] && echo -n ", "
        echo "${QUERY_NUM},${i},${RES}" >> result.csv
    done
    echo "],"

    QUERY_NUM=$((QUERY_NUM + 1))
done
