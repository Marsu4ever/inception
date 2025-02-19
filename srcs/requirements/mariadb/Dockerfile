FROM alpine:3.20.5

#Packages


#RUN apk update

RUN apk update && apk add mariadb mariadb-client

COPY ./mariadb-script.sh /tmp/mariadb-script.sh
RUN chmod +x /tmp/mariadb-script.sh


ENTRYPOINT ["/tmp/mariadb-script.sh"]
