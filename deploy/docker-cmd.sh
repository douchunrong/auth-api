#!/bin/bash

set -e

DB_HOST=${DB_HOST:-auth-db}
dockerize -wait tcp://${DB_HOST}:5432

if [ -f /volume/shared/is_leader ]; then
    bin/rake db:migrate
fi

exec  bin/rails server -p 3030 -b 0.0.0.0
