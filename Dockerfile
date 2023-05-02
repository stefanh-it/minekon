FROM eclipse-temurin:17-jdk-jammy 

ARG MC_VERSION=1.19.4
ARG MEM_LIMIT=7G
ARG USER=minecraft-docker
ARG GROUP=minecraft-docker
ARG UID=2000
ARG GID=2000
ARG PLUGIN_DIR=/plugins
ARG WORLD_DIR=/world
ARG EULA=true
ENV MC_VERSION=$MC_VERSION
ENV USER=$USER
ENV GROUP=$GROUP
ENV MEM_LIMIT=$MEM_LIMIT
ENV PLUGIN_DIR=$PLUGIN_DIR
ENV WORLD_DIR=$WORLD_DIR

RUN apt-get update \
    && apt-get install  -y git wget gosu

VOLUME ${WORLD_DIR}
VOLUME ${PLUGIN_DIR}
WORKDIR /minecraft

RUN mkdir -p ${WORLD_DIR} ${PLUGIN_DIR} 

RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
    && java -jar BuildTools.jar --rev $MC_VERSION \
    && echo "eula=${EULA}" > eula.txt

RUN apt-get remove -y git wget \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${GID} ${GROUP} \
    && useradd -u ${UID} -g ${GROUP} -s /bin/sh -m ${USER} \
    && chown ${USER}:${GROUP} . -R \
    && chown ${USER}:${GROUP} ${WORLD_DIR} -R \
    && chown ${USER}:${GROUP} ${PLUGIN_DIR} -R

COPY docker-entrypoint.sh .
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
