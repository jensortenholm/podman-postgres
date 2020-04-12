# postgres container
#
# podman run -d --read-only --name pg -e POSTGRES_PWD=mypassword localhost/postgres:latest

FROM docker.io/centos:8

ENV HOME=/var/lib/pgsql/data \
    POSTGRES_PWD="postgres"

RUN dnf -y install postgresql-server postgresql-contrib nss_wrapper \
    && dnf -y clean all \
    && mkdir -p /var/lib/pgsql/data \
    && mkdir -p /var/run/postgresql \
    && chown -R 1000:0 /var/lib/pgsql /var/run/postgresql \
    && chmod -R g=u /var/lib/pgsql /var/run/postgresql

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY bashrc /usr/local/bin/bashrc

VOLUME /var/lib/pgsql/data

EXPOSE 5432

USER 1000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["-c", "listen_addresses=0.0.0.0", "-c", "log_connections=on", "-c", "log_disconnections=on", "-c", "logging_collector=off"]
