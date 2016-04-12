#!/bin/bash

set -e

dockerize -wait tcp://auth-db:5432

if [ -f /volume/shared/is_leader ]; then
    bin/rake db:migrate
fi

exec  bin/rails server -p 3030 -b 0.0.0.0
