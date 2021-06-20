#!/bin/bash

set -e
USER=infra

main() {
  echo "==================================================================="
  echo -e "Initialize.."
  copyAWSConfig /host/home/.aws /infra/.aws/
  #SyncronizetfState state-tf-aws-useast1
  source <(yq shell-completion bash)
  bash
  echo "==================================================================="
}

copyAWSConfig(){
    HOMEDIR=$1
    cp -r $HOMEDIR ~/.aws/
}

SyncronizetfState(){
    DIR=$1
    aws s3 sync s3://${DIR} .terraform/
}

# Sync directory on $path if $path is provided, otherwise copy files from $pathForCopy to $path
function syncOrCopy() {
  name=$1
  path=$2
  pathForCopy=$3

  if [[ -d "$path" ]]; then
    echo " - $name directory will be synced"
  else
    if [[ -d "$pathForCopy" ]]; then
      echo " - $name directory will be copied"
      mkdir -p $path
      rsync -ar $pathForCopy/ $path/
    else
      echo "Please map $name volume: $path (synced) or $pathForCopy (not synced)"
      exit 1
    fi
  fi
}

main
