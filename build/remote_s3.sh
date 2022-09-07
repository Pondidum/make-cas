#!/bin/sh

bucket="${CAS_S3_BUCKET_PATH%%/}"

s3="${CAS_S3_CMD:-"aws --endpoint-url http://localhost:9000 s3"}"

log() {
  if [ -n "$CAS_VERBOSE" ]; then
    echo "$1" >&2
  fi
}

fetch_state() {
  key="$1"
  state_path="$2"
  log "$key: Fetching remote state to $state_path"


  $s3 cp "s3://${bucket}/state/${key}" "${state_path}" --quiet >&2 || true
}

store_state() {
  key="$1"
  state_path="$2"
  log "$key: Storing state from $state_path"

  $s3 cp "${state_path}" "s3://${bucket}/state/${key}" --quiet >&2
}

fetch_artifacts() {
  key="$1"
  shift

  for artifact in "$@"; do
    log "$key: Fetching $artifact"
    $s3 cp "s3://${bucket}/artifacts/${key}/${artifact}" "${artifact}" --quiet >&2
  done

}

store_artifact() {
  key="$1"
  artifact="$2"
  log "$key: Storing artifact $artifact"

  $s3 cp "${artifact}" "s3://${bucket}/artifacts/${key}/${artifact}" --quiet >&2
}


# -----------------------

if [ $# -eq 0 ]; then
  echo "you must supply a command"
  exit 1
fi

action="$1"
shift

case "$action" in
  fetch-state)      fetch_state "$@" ;;
  store-state)      store_state "$@" ;;
  fetch-artifacts)  fetch_artifacts "$@" ;;
  store-artifact)   store_artifact "$@" ;;
  *) echo "unknown command $action" >&2 ; exit 1;;
esac
