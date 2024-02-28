#!/bin/bash

set -e

export MONGO_URI=${MONGO_URI:-mongodb://mongo:27017}
export TARGET_FOLDER=${TARGET_FOLDER-/backup} 
export AWS_CLI_ARGS=${AWS_CLI_ARGS:- }

exec /backup.sh
