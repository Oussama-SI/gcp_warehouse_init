#!/bin/bash

export PROJECT_ID=$(gcloud config get-value project)
export REGION=us-central1
gcloud config set compute/region $REGION

gcloud config set run/region $REGION
gcloud config set run/platform managed
gcloud config set eventarc/location $REGION

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com

# set the PROJECT_NUMBER variable:
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

# Optional
# gcloud iam service-accounts create cloud-run-sa --display-name "Cloud Run Service Account"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
    --role="roles/eventarc.eventReceiver"

# crée un compte de service géré par Google pour Google Cloud Storage dans ton projet.
gcloud beta services identity create --service=storage.googleapis.com --project=$PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:service-$PROJECT_NUMBER@gs-project-accounts.iam.gserviceaccount.com" \
    --role='roles/pubsub.publisher'

