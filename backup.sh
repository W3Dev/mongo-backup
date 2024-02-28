#!/bin/bash

set -eo pipefail
echo "Job started on: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)

mongodump --uri "$MONGO_URI" --gzip --archive | aws s3 cp - "${TARGET_S3_FOLDER%/}/backup-$DATE.tar.gz" $AWS_CLI_ARGS
echo "Mongo dump uploaded to $TARGET_S3_FOLDER"

echo "Job finished: $(date)"
