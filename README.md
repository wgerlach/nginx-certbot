# nginx-certbot
docker-compose of nginx and certbot for automated SSL creation and renewal


## 1) nginx.conf
put domain names in nginx.conf


## 2) ssl.conf
Copy `include_ssl/ssl.conf_template` to `include_ssl/ssl.conf` and put in certiticate name, or use:

```bash
source config.src
envsubst < ./include_ssl/ssl.conf_template > ./include_ssl/ssl.conf
```


## 3) systemd unit
```bash
export GIT_REPO=${PWD}
export WWW_DIR=${PWD}/www
envsubst < webserver.service_template > webserver.service
./deploy.sh

```