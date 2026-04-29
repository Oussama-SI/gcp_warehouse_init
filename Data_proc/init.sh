#!/bin/badh

gcloud compute networks subnets update default --region=us-central1 --enable-private-ip-google-access

gsutil mb -p  qwiklabs-gcp-03-edef090fb17b gs://qwiklabs-gcp-03-edef090fb17b

gsutil mb -p  qwiklabs-gcp-03-edef090fb17b gs://qwiklabs-gcp-03-edef090fb17b-bqtemp

bq --location=us-central1 mk --dataset qwiklabs-gcp-03-edef090fb17b:taxi_trips || bq mk -d  loadavro

# in a small vm : 
     wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/campaigns.avro
     gcloud storage cp campaigns.avro gs://qwiklabs-gcp-03-edef090fb17b
     wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/dataproc-templates.zip
     unzip dataproc-templates.zip

     export GCP_PROJECT=qwiklabs-gcp-03-edef090fb17b
     export REGION=us-central1
     export GCS_STAGING_LOCATION=gs://qwiklabs-gcp-03-edef090fb17b
     export JARS=gs://cloud-training/dataengineering/lab_assets/idegc/spark-bigquery_2.12-20221021-2134.jar

     ./bin/start.sh \
     -- --template=GCSTOBIGQUERY \
     --gcs.bigquery.input.format="avro" \
     --gcs.bigquery.input.location="gs://qwiklabs-gcp-03-edef090fb17b" \
     --gcs.bigquery.input.inferschema="true" \
     --gcs.bigquery.output.dataset="loadavro" \
     --gcs.bigquery.output.table="campaigns" \
     --gcs.bigquery.output.mode=overwrite\
     --gcs.bigquery.temp.bucket.name="qwiklabs-gcp-03-edef090fb17b-bqtemp"

     bq query \
     --use_legacy_sql=false \
     'SELECT * FROM `loadavro.campaigns`;'


