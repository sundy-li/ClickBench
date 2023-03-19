
import timeit
import psutil
from pathlib import Path

from datafusion import SessionContext

# Create a DataFusion context
ctx = SessionContext()

# Register table with context
ctx.register_parquet('lineitem',   '../data/lineitem/*.parquet')
ctx.register_parquet('orders',     '../data/orders/*.parquet')
ctx.register_parquet('partsupp',   '../data/partsupp/*.parquet')
ctx.register_parquet('supplier',   '../data/supplier/*.parquet')
ctx.register_parquet('nation',     '../data/nation/*.parquet')
ctx.register_parquet('region',     '../data/region/*.parquet')
ctx.register_parquet('customer',   '../data/customer/*.parquet')
ctx.register_parquet('part',       '../data/part/*.parquet')

# end = timeit.default_timer()
# print(end - start)

sql = Path('../duckdb/tpch.sql').read_text()

def execute_query(ctx, sql_script):
    sql_arr = sql_script.split(";")
    for index, value in enumerate(sql_arr,start=1):
        if index == 17 or index == 18:
            print("OOM")
            continue
        if len(value.strip()) > 0:
            for i in range(0, 1):
                start = timeit.default_timer()
                try : 
                    df = ctx.sql(value)
                    c = df.count()
                    end = timeit.default_timer()
                    duration = end - start
                except Exception as e:
                    print(e)
                    duration = 0
                print(duration)
                
execute_query(ctx, sql)

