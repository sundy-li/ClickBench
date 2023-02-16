COPY INTO hits FROM 'https://datasets.clickhouse.com/hits_compatible/hits.tsv.gz' file_format=(type='TSV' field_delimiter='\t' record_delimiter='\n' skip_header=1 compression = 'gzip');
