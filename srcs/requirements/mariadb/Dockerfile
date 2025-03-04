FROM alpine:3.20.5

RUN apk update && apk add mariadb mariadb-client

COPY ./conf/mariadb_config /etc/my.cnf.d/mariadb_config
RUN chmod 644 /etc/my.cnf.d/mariadb_config

COPY ./tools/mariadb-script.sh /tmp/mariadb-script.sh
RUN chmod +x /tmp/mariadb-script.sh


ENTRYPOINT ["/tmp/mariadb-script.sh"]
