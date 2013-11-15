#!/bin/bash

HOST="fraked.debian.net"

ssh ${HOST} "cd /srv/www/uwsgi/app/snitch/; git pull; cd web; make"

ssh -l www ${HOST} kill-apps
ssh -l www ${HOST} start-apps
