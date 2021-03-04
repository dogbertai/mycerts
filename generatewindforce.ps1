New-Item -Path out -ItemType directory -ErrorAction SilentlyContinue
docker run -v ${PWD}:/work -it --rm nginx openssl req -newkey rsa:2048 -nodes -config /work/windforcereq.conf -keyout /work/out/windforcekey.pem -out /work/out/windforcereq.pem
docker run -v ${PWD}:/work -it --rm nginx openssl x509 -req -in /work/out/windforcereq.pem -CA /work/out/rootcert.pem -CAkey /work/out/rootkey.pem -CAcreateserial -days 30 -extensions v3_req -extfile /work/windforcereq.conf -out /work/out/windforcecert.pem
kubectl delete secret default-ssl-cert
kubectl create secret tls default-ssl-cert --key .\out\windforcekey.pem --cert .\out\windforcecert.pem