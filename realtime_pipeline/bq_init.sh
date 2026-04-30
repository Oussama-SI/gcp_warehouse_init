#!/bin/bash

bq --location=us-central1 mk taxirides

bq --location=us-central1 mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime

# move necessary data to Dataflow pipeline
gcloud storage cp gs://cloud-training/bdml/taxisrcdata/schema.json  gs://qwiklabs-gcp-01-4f749a2e7e24-bucket/tmp/schema.json
gcloud storage cp gs://cloud-training/bdml/taxisrcdata/transform.js  gs://qwiklabs-gcp-01-4f749a2e7e24-bucket/tmp/transform.js
gcloud storage cp gs://cloud-training/bdml/taxisrcdata/rt_taxidata.csv  gs://qwiklabs-gcp-01-4f749a2e7e24-bucket/tmp/rt_taxidata.csv

gcloud services enable dataflow.googleapis.com

#in data flow + create from template
  # Enable Dataflow API
  #Enable Data Pipelines API
  # Enable Cloud Scheduler API

     # source : qwiklabs-gcp-01-4f749a2e7e24-bucket/tmp/rt_taxidata.csv
     # target : 
