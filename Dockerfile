FROM bpmbee/mono-base:latest

ENV SONARR_BRANCH="phantom-develop"

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
        jq xml-twig-tools && \
 echo "**** install sonarr ****" && \
 mkdir -p /app/sonarr/bin && \
  if [ -z ${SONARR_VERSION+x} ]; then \
	SONARR_VERSION=$(curl -sX GET https://services.sonarr.tv/v1/download/${SONARR_BRANCH}?version=3 \
	| jq -r '.version'); \
 fi && \
 curl -o \
	/tmp/sonarr.tar.gz -L \
	"https://download.sonarr.tv/v3/${SONARR_BRANCH}/${SONARR_VERSION}/Sonarr.${SONARR_BRANCH}.${SONARR_VERSION}.linux.tar.gz" && \
 tar xf \
	/tmp/sonarr.tar.gz -C \
	/app/sonarr/bin --strip-components=1 && \
 echo "UpdateMethod=docker\nBranch=${SONARR_BRANCH}\nPackageVersion=${VERSION}\nPackageAuthor=linuxserver.io" > /app/sonarr/package_info && \
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
RUN chmod +x *.sh

EXPOSE 8989
VOLUME /config

HEALTHCHECK --interval=5m --timeout=5s \
  CMD /app/sonarr/bin/healthcheck.sh

ENTRYPOINT ["/app/sonarr/bin/start.sh"]
