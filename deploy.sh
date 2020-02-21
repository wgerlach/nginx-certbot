#!/bin/bash
set -ex
cp webserver.service /etc/systemd/system/
systemctl enable webserver.service
systemctl start webserver.service