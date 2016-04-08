#!/bin/bash

set -e

if [ -f /volume/shared/is_leader ]; then
    bin/rake db:migrate
fi

exec  bin/rails server -p 3030 -b 0.0.0.0
