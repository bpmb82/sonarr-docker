FROM debian:bookworm-slim

ENV SONARR_BRANCH="develop"

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
        jq xml-twig-tools curl libicu72 libsqlite3-0 && \
 echo "**** install sonarr ****" && \
 mkdir -p /app/sonarr && \
  if [ -z ${SONARR_URL+x} ]; then \
	SONARR_URL=$(curl -sX GET https://services.sonarr.tv/v1/download/${SONARR_BRANCH}?version=4 | jq -r '.linux.x64.archive.url'); \
 fi && \
 curl -s -o \
	/tmp/sonarr.tar.gz -L \
	"${SONARR_URL}" && \
 tar xf \
	/tmp/sonarr.tar.gz -C \
	/app/sonarr --strip-components=1 && \
 rm -rf /tmp/sonarr.tar.gz && \
 rm -rf /app/sonarr/Sonarr.Update && \
 echo "**** cleanup ****" && \
 apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
 rm -rf \
        /tmp/* \
        /var/tmp/*

WORKDIR /app/sonarr
COPY start.sh .
COPY healthcheck.sh .
COPY backup.sh .
RUN chmod +x *.sh

EXPOSE 8989
VOLUME /config
VOLUME /backups


HEALTHCHECK --interval=5m --timeout=5s \
  CMD /app/sonarr/healthcheck.sh

ENTRYPOINT ["/app/sonarr/start.sh"]
