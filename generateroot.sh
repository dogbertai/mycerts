#!/usr/bin/env bash
set -Eeuo pipefail
trap 's=$?; echo >&2 "$0: Error on line "${LINENO}": ${BASH_COMMAND}"; exit ${s}' ERR

script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
start_dir="${PWD}"

target_path="${PWD}/out"
mkdir -p "${target_path}"

# create x509 cert pair expires 10 years rsa 2048 bit encryption no password name rootkey is private rootcert is public
openssl req -x509 -days 3650 -newkey rsa:2048 -nodes -subj "/C=US/CN=dogbertai.net Root CA" -keyout "${target_path}/rootkey.pem" -out "${target_path}/rootcert.pem"

# debug
openssl x509 -noout -text -in "${target_path}/rootcert.pem"