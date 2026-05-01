#!/bin/bash

bp mk create --warehouse=warehouse \
    --region=us-central1 \
    --project=datastream-cdc \
    --display-name=warehouse \
    --description="Warehouse for CDC data" \

bo load 