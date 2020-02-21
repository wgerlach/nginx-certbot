# nginx-certbot
docker-compose of nginx and certbot for automated SSL creation and renewal


## 1) nginx.conf
put domain names in nginx.conf


## 2) ssl.conf
Copy `include_ssl/ssl.conf_template` to `include_ssl/ssl.conf` and put in certiticate name, or use:

```bash
set -o allexport
source config.src
set +o allexport
envsubst < ./include_ssl/ssl.conf_template > ./include_ssl/ssl.conf
```

## 3) start

```bash
sudo -i
cd /home/ubuntu/nginx-certbot/
docker-compose -f docker-compose.yml -f docker-compose-certbot.yml up

```






## x)  systemd unit (OUTDATED)
```bash
export GIT_REPO=${PWD}
export WWW_DIR=${PWD}/www
envsubst < webserver.service_template > webserver.service
./deploy.sh

```