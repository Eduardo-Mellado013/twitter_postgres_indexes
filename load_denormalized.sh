#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 path/to/geoTwitterYYYY-MM-DD.zip" >&2
  exit 1
fi

unzip -p "$1" | \
  # 1) strip literal \u0000
  # 2) remove any ,"truncated":<value> up to the next comma or closing brace
  sed -r 's/\\u0000//g; s/,"truncated":[^,}]*//g' | \
  psql "postgresql://postgres:pass@localhost:8763/" \
       -c "COPY tweets_jsonb(data)
           FROM STDIN
           CSV
           QUOTE E'\x01'
           DELIMITER E'\x02';"

