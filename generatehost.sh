#!/usr/bin/env bash
set -Eeuo pipefail
trap 's=$?; echo >&2 "$0: Error on line "${LINENO}": ${BASH_COMMAND}"; exit ${s}' ERR

script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
start_dir="${PWD}"

target_path="${PWD}/out"
mkdir -p "${target_path}"
name=host

# create key and request rsa 2048 bit encryption no password metadata in conf hostkey is private hostreq is request
openssl req -newkey rsa:2048 -nodes -config "${script_dir}/${name}req.conf" -keyout "${target_path}/${name}key.pem" -out "${target_path}/${name}req.pem"
# sign x509 request using CA cert and key, create serial, expire 1 month, add extension metadata in conf, hostcert is public
openssl x509 -req -in "${target_path}/${name}req.pem" -CA "${target_path}/intecert.pem" -CAkey "${target_path}/intekey.pem" -CAcreateserial -days 30 -extensions v3_req -extfile "${script_dir}/${name}req.conf" -out "${target_path}/${name}cert.pem"

# debug
openssl x509 -noout -text -in "${target_path}/${name}cert.pem"