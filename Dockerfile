FROM ubuntu:24.04

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ARG UID=2000
ARG GID=2000

LABEL maintainer="Stefan Ruepp <stefan@ruepp.info>"
LABEL github="https://github.com/MyUncleSam/docker-foundry/"
LABEL TARGETPLATFORM=${TARGETPLATFORM}
LABEL BUILDPLATFORM=${BUILDPLATFORM}

ENV GAMESERVER_CMD="FoundryDedicatedServer.exe -log"
ENV GAMESERVER_FILES="/server"
ENV STEAM_GAMESERVERID="2915550"
ENV STEAM_ADDITIONAL_UPDATE_ARGS=""
ENV TZ="Europe/Berlin"

ADD scripts/dockerfile/ /build

RUN /bin/bash /build/build.sh \
    && groupadd -g ${GID} steam \
    && useradd -u ${UID} -g ${GID} -m -s /bin/bash steam

USER steam

EXPOSE 3724
EXPOSE 27015

VOLUME [ "/server", "/foundry", "/home/steam/Steam" ]
CMD [ "/docker/start.sh" ]