FROM bpmbee/mono-base:latest

ENV SONARR_BRANCH="main"

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
        jq xml-twig-tools && \
 echo "**** install sonarr ****" && \
 mkdir -p /app/sonarr/bin && \
  if [ -z ${SONARR_URL+x} ]; then \
	SONARR_URL=$(curl -sX GET https://services.sonarr.tv/v1/download/${SONARR_BRANCH}?version=3 \
	| jq -r '.linux.manual.url'); \
 fi && \
 curl -o \
	/tmp/sonarr.tar.gz -L \
	"${SONARR_URL}" && \
 tar xf \
	/tmp/sonarr.tar.gz -C \
	/app/sonarr/bin --strip-components=1 && \
 rm -rf /app/sonarr/bin/Sonarr.Update && \
 echo "**** cleanup ****" && \
 apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
 rm -rf \
        /tmp/* \
        /var/tmp/*

WORKDIR /app/sonarr/bin
COPY start.sh .
COPY healthcheck.sh .
COPY backup.sh .
RUN chmod +x *.sh

EXPOSE 8989
VOLUME /config
VOLUME /backups


HEALTHCHECK --interval=5m --timeout=5s \
  CMD /app/sonarr/bin/healthcheck.sh

ENTRYPOINT ["/app/sonarr/bin/start.sh"]
