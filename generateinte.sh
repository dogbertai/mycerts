#!/usr/bin/env bash
set -Eeuo pipefail
trap 's=$?; echo >&2 "$0: Error on line "${LINENO}": ${BASH_COMMAND}"; exit ${s}' ERR

script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
start_dir="${PWD}"

target_path="${PWD}/out"
mkdir -p "${target_path}"

# create key and request rsa 2048 bit encryption no password metadata key is private req is request
openssl req -newkey rsa:2048 -nodes -subj "/C=US/CN=dogbertai.net Intermediate CA" -keyout "${target_path}/intekey.pem" -out "${target_path}/intereq.pem"

# sign x509 request using CA cert and key, create serial, expire 1 year, cert is public
openssl x509 -req -in "${target_path}/intereq.pem" -CA "${target_path}/rootcert.pem" -CAkey "${target_path}/rootkey.pem" -CAcreateserial -days 365 -extensions v3_ca -extfile "${script_dir}/intereq.conf" -out "${target_path}/intecert.pem"

cat "${target_path}/intecert.pem" "${target_path}/rootcert.pem" > "${target_path}/ca-bundle.pem"

# debug
openssl x509 -noout -text -in "${target_path}/intecert.pem"
openssl verify -CAfile "${target_path}/rootcert.pem" "${target_path}/ca-bundle.pem"