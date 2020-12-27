FROM bpmbee/mono-base:latest

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
        jq xml-twig-tools && \
 echo "**** install sonarr ****" && \
 curl -L \
        "http://update.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz" \
        -o /opt/NzbDrone.tar.gz && \
 cd /opt && \
 tar zxvf NzbDrone.tar.gz && \
 rm NzbDrone.tar.gz && \
 cd NzbDrone && \
 echo "**** cleanup ****" && \
 apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
 rm -rf \
        /tmp/* \
        /var/tmp/*

WORKDIR /opt/NzbDrone
COPY start.sh .
COPY healthcheck.sh .
COPY backup.sh .
RUN chmod +x *.sh

EXPOSE 8989
VOLUME /config
VOLUME /backups

HEALTHCHECK --interval=5m --timeout=5s \
  CMD /opt/NzbDrone/healthcheck.sh

ENTRYPOINT ["/opt/NzbDrone/start.sh"]
