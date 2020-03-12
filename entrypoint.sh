#!/bin/bash
TOKEN=$1
REPOSITORY_OWNER=$2
PR_PAYLOAD=$3

set_dependency_status_code() {
  responseCode=$(curl -X GET -u $TOKEN:x-oauth-basic "https://api.github.com/repos/$REPOSITORY_OWNER/$formattedUrl/merge" --write-out %{http_code} --silent --output /dev/null)

  #204 No Content = has been merged
  #404 has not been merged
  #400 ?error?
}

set_formatted_dependency_url() {
  format_input=$1
  needleFullString="Depends on "
  replaceFullString=""
  raw=${format_input/$needleFullString/$replaceFullString}

  needleUrl="/"
  replaceUrl="/pulls/"
  formattedUrl=${raw/$needleUrl/$replaceUrl}
}

fetch_dependency() {
  dependency_input=$1
  set_formatted_dependency_url "$dependency_input"
  set_dependency_status_code "$formattedUrl"


  if [[ $responseCode == 204 ]]; then
    #exit success
    echo "Dependency merged!"
    exit 0
  fi

  if [[ $responseCode == 404 ]]; then
    #exit error
    echo "Dependency not merged yet!"
    exit 1
  fi

  echo "Unexpected error occured"
  echo "responsecode : $responseCode"
  exit 2
}

process_payload() {
  input="$1"
  needle="Depends on"
  needleNoDependency="$needle null"
  needleDependency="$needle */+([0-9])"

  case "$input" in
    $needleNoDependency)
      echo "needle no dependency"; exit 0;;#exit success
    $needleDependency)
      fetch_dependency "$input"; exit 0;;
    *)
      echo "no match found, please add the required keywords!"; exit 1;;#exit error
  esac
}

shopt -s extglob
payloadBody="${PR_PAYLOAD}"
process_payload "$payloadBody"
