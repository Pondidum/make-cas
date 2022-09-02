#!/bin/sh

STORE_PATH="${CAS_STORE_PATH:-.state}"
mkdir -p "${STORE_PATH}"

now=$(date "+%s")
current_hash=$(echo "$@" | xargs -n 1 | LC_ALL=C sort | xargs sha256sum | sha256sum | cut -d" " -f 1)

key="${current_hash}.sha256"
state_path="${STORE_PATH}/${key}"

if [ -f "${state_path}" ]; then
  # this hash is in the state store, re-apply it's date to the state file (as something like s3
  # sync might have changed the file's modified date.
  last_date=$(sed -n 's/date:\s*\(.*\)/\1/p' "${state_path}")
  touch -d "@${last_date}" "${state_path}"

else
  # this is a new hash
  echo "date: $now" > "${state_path}"
fi

echo "${state_path}"