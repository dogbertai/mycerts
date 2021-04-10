param (${Name})
New-Item -Path out -ItemType directory -ErrorAction SilentlyContinue
docker run -v "${PWD}:/work" -it --rm nginx openssl req -newkey rsa:2048 -nodes -subj "/C=US/CN=dogbertai.net Intermediate CA" -keyout /work/out/intekey.pem -out /work/out/intereq.pem
docker run -v "${PWD}:/work" -it --rm nginx openssl x509 -req -in /work/out/intereq.pem -CA /work/out/rootcert.pem -CAkey /work/out/rootkey.pem -CAcreateserial -days 365 -extensions v3_ca -extfile /work/intekey.conf -out /work/out/intecert.pem