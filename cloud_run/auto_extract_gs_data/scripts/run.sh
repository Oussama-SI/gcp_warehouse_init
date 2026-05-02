#!/bin/bash
# To run in gcloud environment

# This script is used to initialize the Cloud Run environment for the application.
npm install @google-cloud/storage @google-cloud/bigquery

# Note: If you see an error message relating to eventarc
# service agent propagation, wait a few minutes and try the command again.
gcloud functions deploy loadBigQueryFromAvro \
    --gen2 \
    --runtime nodejs24 \
    --source . \
    --region $REGION \
    --trigger-resource gs://$PROJECT_ID \
    --trigger-event google.storage.object.finalize \
    --memory=512Mi \
    --timeout=540s \
    --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com 


# show the deployed function
gcloud functions describe loadBigQueryFromAvro --gen2 --region $REGION

# show the deployed eventarc trigger
gcloud eventarc triggers list --location=$REGION

# Download the avro file to test the function locally
wget https://storage.googleapis.com/cloud-training/dataengineering/lab_assets/idegc/campaigns.avro


