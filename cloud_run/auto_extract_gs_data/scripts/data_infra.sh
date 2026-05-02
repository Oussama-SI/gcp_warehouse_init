#!/bin/bash

gcloud storage buckets create gs://$PROJECT_ID --location=$REGION

bq mk -d  loadavro