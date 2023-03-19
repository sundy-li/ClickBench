
import duckdb
import timeit
import psutil
from pathlib import Path

con = duckdb.connect(database="data.duckdb", read_only=False)

# print("Set up a view over the Parquet files")

start = timeit.default_timer()

# create table lineitem as select * from  read_parquet('../data/lineitem/*.parquet');
# create table orders as select * from    read_parquet('../data/orders/*.parquet');
# create table partsupp as select * from  read_parquet('../data/partsupp/*.parquet');
# create table supplier as select * from  read_parquet('../data/supplier/*.parquet');
# create table nation as select * from    read_parquet('../data/nation/*.parquet');
# create table region as select * from    read_parquet('../data/region/*.parquet');
# create table customer as select * from  read_parquet('../data/customer/*.parquet');
# create table part as select * from      read_parquet('../data/part/*.parquet');


# end = timeit.default_timer()
# print(end - start)

sql = Path('tpch.sql').read_text()

def execute_query(engine, sql_script):
    sql_arr = sql_script.split(";")
    for index, value in enumerate(sql_arr,start=1):
        if len(value.strip()) > 0:
            for i in range(0, 3):
                start = timeit.default_timer()
                try : 
                    data = engine.execute(value).fetchall()
                    end = timeit.default_timer()
                    duration = end - start
                except Exception as e:
                    print(e)
                    duration = 0
                print(duration)
                
execute_query(con, sql)

