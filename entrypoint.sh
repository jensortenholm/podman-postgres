#!/bin/bash

export LD_PRELOAD='/usr/lib64/libnss_wrapper.so'
export NSS_WRAPPER_PASSWD="$(mktemp)"
export NSS_WRAPPER_GROUP="$(mktemp)"
echo "postgres:x:$(id -u):$(id -g):PostgreSQL:/var/lib/pgsql/data:/bin/false" > "$NSS_WRAPPER_PASSWD"
echo "postgres:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

if [[ ! -f /var/lib/pgsql/data/postgresql.conf ]]; then
  initdb --username=postgres --pwfile=<(echo "${POSTGRES_PWD}") -A scram-sha-256 --encoding=UTF8 /var/lib/pgsql/data
  echo "host all all all scram-sha-256" >> /var/lib/pgsql/data/pg_hba.conf
  cp /usr/local/bin/bashrc /var/lib/pgsql/data/.bashrc
fi

/usr/bin/postmaster -D /var/lib/pgsql/data "$@"
