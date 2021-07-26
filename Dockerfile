FROM ubuntu:20.04

# ENV KONG_VERSION 2.3.3

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates curl perl unzip zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -fsSLo kong.deb https://download.konghq.com/gateway-2.x-ubuntu-bionic/pool/all/k/kong/kong_2.4.1_amd64.deb \
	&& apt-get purge -y --auto-remove ca-certificates curl \
	&& dpkg -i kong.deb \
	&& rm -rf kong.deb 

RUN apt-get update && apt-get install vim -y
 

COPY ./conf/ /etc/kong/

COPY ./plugins/ /opt/

COPY ./scripts/ .

RUN ["chmod", "+x", "./docker-entrypoint.sh"]

ENTRYPOINT [ "./docker-entrypoint.sh"]

# EXPOSE ${KONG_PG_LISTEN} ${KONG_ADMIN_PG_LISTEN} ${KONG_PG_LISTEN_SSL} ${KONG_ADMIN_PG_LISTEN_SSL}
EXPOSE 3100 3101 3102 3103

STOPSIGNAL SIGQUIT

CMD ["kong", "docker-start"]

