#!/bin/bash

TODAY=$(date +"%Y-%m-%d")
TIME=$(date +"%Y%m%d%H%M%S")

for COLLECTION in $COLLECTIONS
do
    if [ "$FORMAT" == "json" ]; then
        mongodump --uri $MONGO_HOST --port $MONGO_PORT -u $MONGO_USER -p $MONGO_PASS -d $MONGO_DB -c $COLLECTION --out=- | gzip > $COLLECTION.json.gz
    elif [ "$FORMAT" == "csv" ]; then
        mongoexport --uri $MONGO_HOST -u $MONGO_USER -p $MONGO_PASS -d $MONGO_DB -c $COLLECTION --type=csv --out=$COLLECTION.csv
        gzip $COLLECTION.csv
    fi
        aws s3 cp $COLLECTION.$FORMAT.gz s3://$S3_BUCKET/raw/mongodb/$COLLECTION/date=$TODAY/$TIME.$FORMAT.gz --region $REGION
        rm $COLLECTION.$FORMAT.gz
done