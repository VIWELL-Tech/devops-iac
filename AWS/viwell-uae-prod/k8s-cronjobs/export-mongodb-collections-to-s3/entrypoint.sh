#!/bin/bash

set -e

TODAY=$(date +"%Y-%m-%d")
TIME=$(date +"%Y%m%d%H%M%S")

# Loop through each database
for DB in $DBS; do
    # Replace hyphens with underscores for variable names
    DB_UNDERSCORE=$(echo "$DB" | tr '-' '_')
    # Dynamically get the collections for the current DB using indirect reference
    COLLECTIONS_VAR="${DB_UNDERSCORE}_COLLECTIONS"
    COLLECTIONS="${!COLLECTIONS_VAR}"
    # Loop through each collection for the current DB
    for COLLECTION in $COLLECTIONS; do
        if [ "$FORMAT" == "json" ]; then
            OUTPUT_FILE="$DB.$COLLECTION.json"
            mongoexport --uri "$MONGO_HOST" --port "$MONGO_PORT" -u "$MONGO_USER" -p "$MONGO_PASS" -d "$DB" -c "$COLLECTION" --out="${OUTPUT_FILE}"
            gzip "${OUTPUT_FILE}"
        elif [ "$FORMAT" == "csv" ]; then
            OUTPUT_FILE="$DB.$COLLECTION.csv.gz"
            mongoexport --uri "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASS" -d "$DB" -c "$COLLECTION" --type=csv --out "${OUTPUT_FILE}"
            gzip "${OUTPUT_FILE}"
        fi

        aws s3 cp "$OUTPUT_FILE.gz" "s3://$S3_BUCKET/raw/mongodb/$DB/$COLLECTION/date=$TODAY/$TIME.$FORMAT.gz" --region "$REGION" --content-type "application/json" --content-encoding "gzip"
    	#     rm "$OUTPUT_FILE.gz"
    done
done

# MySQL Dump for assessment-v2

TABLES=$(mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DB -e 'SHOW TABLES;' | tr -d '| ' | grep -v 'Tables_in_')

for T in $TABLES; do
    echo "Exporting $T"

    # File extension and S3 file path format based on FORMAT value
    EXTENSION="csv"
    S3_PATH_FORMAT="s3://$S3_BUCKET/raw/mysql/$MYSQL_DB/$T/date=$TODAY/$TIME.csv"

    if [ "$FORMAT" == "csv" ]; then
        mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DB -e "SELECT * FROM $T" > "${T}.csv"
    elif [ "$FORMAT" == "json" ]; then
        EXTENSION="json"
        S3_PATH_FORMAT="s3://$S3_BUCKET/raw/mysql/$MYSQL_DB/$T/date=$TODAY/$TIME.json"

        # Fetch column names
        COLUMNS=$(mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DB -e "DESCRIBE $T;" | awk '{print $1}' | grep -v 'Field' | xargs)

        # Convert the column names to a format suitable for JSON_OBJECT
       # JSON_COLUMNS=$(echo $COLUMNS | awk 'BEGIN { ORS=""; } { for(i=1; i<=NF; i++) printf("\x27%s\x27, %s, ", $i, $i); }' | sed 's/, $//')
         JSON_COLUMNS=$(echo $COLUMNS | awk 'BEGIN { ORS=""; } { for(i=1; i<=NF; i++) printf("\x27%s\x27, `%s`, ", $i, $i); }' | sed 's/, $//')

        # Fetch data as JSON
        QUERY="SELECT JSON_OBJECT($JSON_COLUMNS) FROM $T;"
        mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DB -e "$QUERY" > "${T}.json"
    else
        echo "Invalid FORMAT. Please set FORMAT to 'csv' or 'json'."
        exit 1
    fi

    # Gzip the exported file
    gzip "${T}.$EXTENSION"

    # Upload to S3
    FILE_NAME="${T}.$EXTENSION.gz"
    aws s3 cp "$FILE_NAME" "$S3_PATH_FORMAT.gz" --region $REGION --content-type "application/json" --content-encoding "gzip"

    # Clean up
    rm "$FILE_NAME"
done