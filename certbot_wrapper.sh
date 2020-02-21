#!/bin/bash
set -e



nginx_reload () {
  sleep 3
  # using the docker socket a reload signal can be sent to nginx
  echo -e "POST /containers/nginx_nginx_1/kill?signal=HUP HTTP/1.0\r\n" |nc local:/tmp/docker.sock
  #nc -U /tmp/docker.sock
  sleep 2
}

sleep 1
if [ ! -e config.src ] ; then
  echo "/config.src not found"
  exit 1
fi
source config.src


if [ ! -z "${CERT_NAME}" ]; then
  echo "Varaible CERT_NAME missing"
  exit 1
fi

if [ ! -z "${DOMAIN_LIST}" ]; then
  echo "Varaible DOMAIN_LIST missing"
  exit 1
fi

if [ ! -z "${EMAIL}" ]; then
  echo "Varaible EMAIL missing"
  exit 1
fi



if [ ! -e  /etc/letsencrypt/dhparam.pem ] ; then
  set -x
  /usr/bin/openssl dhparam -out /etc/letsencrypt/dhparam.pem 2048
  set +x
fi


# check if cert has to be created

if [ ! -e /etc/letsencrypt/live/${CERT_NAME}/fullchain.pem ] ; then
  echo "request new certificate"
  sleep 3

    # for testing: --staging \
  set -x
  certbot certonly \
    --staging \
    --standalone \
    --cert-name ${CERT_NAME} \
    -d ${DOMAIN_LIST}  \
    --text --agree-tos --email ${EMAIL}  --rsa-key-size 4096 \
    --verbose --renew-by-default -n --preferred-challenges http-01
  set +x

fi

if [ ! -e /etc/nginx/include_ssl/ssl.enabled ] ; then
  #activate SSL in nginx
  set -x
  ln -sf /etc/nginx/include_ssl/ssl.conf /etc/nginx/include_ssl/ssl.enabled
  set +x

  #reload nginx config
  nginx_reload
fi



echo "going into renewal loop..."
sleep 3

while true ; do
    set -x
    certbot renew
	  sleep 1d
    set +x
done






