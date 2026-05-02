#!/bin/bash

bq query \
 --use_legacy_sql=false \
 'SELECT * FROM `loadavro.campaigns`;'

# examine the logs for your Cloud Run function
gcloud logging read "resource.labels.service_name=loadBigQueryFromAvro"
