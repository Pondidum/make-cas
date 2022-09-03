#!/bin/sh

key="$1"
artifact="$2"

if [ -n "$CAS_VERBOSE" ]; then
  echo "Storing ${artifact}"
fi

echo "artifact: ${artifact}" >> "${key}"
