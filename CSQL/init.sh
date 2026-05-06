#!/bin/bash

# according to GC , the first Cloud SQL instance created in a project is free
POSTGRES_INSTANCE=postgres-db
DATASTREAM_IPS=34.72.28.29,34.67.234.134,34.67.6.157,34.72.239.218,34.71.242.81
gcloud sql instances create ${POSTGRES_INSTANCE} \
    --database-version=POSTGRES_14 \
    --cpu=2 --memory=10GB \
    --authorized-networks=${DATASTREAM_IPS} \
    --region=us-central1 \
    --root-password pwd \
    --database-flags=cloudsql.logical_decoding=on


gcloud sql connect postgres-db --user=postgres

# postgres=> CREATE ROLE datastream REPLICATION LOGIN ENCRYPTED PASSWORD 'pwd';

'CREATE PUBLICATION test_publication FOR ALL TABLES;
ALTER USER POSTGRES WITH REPLICATION;
SELECT PG_CREATE_LOGICAL_REPLICATION_SLOT('test_replication', 'pgoutput');'

"Balance data staleness and BigQuery costs
Select a default table staleness limit 
to balance BigQuery query performance and cost versus data freshness. Depending on the data pattern and the source table's
primary key, BigQuery might read the entire table every time changes are applied. 
You can use BigQuery reservations to allocate dedicated BigQuery compute resources
 for CDC row modification operations and set a cap on the cost of performing these operations."
