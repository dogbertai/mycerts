param (${Name})
New-Item -Path out -ItemType directory -ErrorAction SilentlyContinue
docker run -v "${PWD}:/work" -it --rm nginx openssl req -newkey rsa:2048 -nodes -config /work/${Name}req.conf -keyout /work/out/${Name}key.pem -out /work/out/${Name}req.pem
docker run -v "${PWD}:/work" -it --rm nginx openssl x509 -req -in /work/out/${Name}req.pem -CA /work/out/intecert.pem -CAkey /work/out/intekey.pem -CAcreateserial -days 30 -extensions v3_req -extfile /work/${Name}req.conf -out /work/out/${Name}cert.pem