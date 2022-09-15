#!/bin/sh

key="$1"
artifact="$2"

if [ -n "$CAS_VERBOSE" ]; then
  echo "Storing ${artifact}"
fi

echo "artifact: ${artifact}" >> "${key}"

if [ -f "${CAS_REMOTE}" ] && [ "$CAS_READ_ONLY" = "0" ]; then
  hash="$(basename "${key}")"
  ${CAS_REMOTE} store-artifact "${hash}" "${artifact}"
  ${CAS_REMOTE} store-state "${hash}" "${key}"
fi
