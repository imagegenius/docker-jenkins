FROM ghcr.io/imagegenius/baseimage-alpine:3.17

# set version label
ARG BUILD_DATE
ARG VERSION
ARG JENKINS_VERSION
LABEL build_version="ImageGenius Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydazz"

# environment settings
ENV \
  JENKINS_HOME="/config" \
  PLUGIN_CLI_VERSION="2.12.11"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache bash \
    coreutils \
    openjdk17-jre \
    git \
    git-lfs \
    musl-locales \
    musl-locales-lang \
    openssh-client \
    ttf-dejavu \
    unzip && \
  git lfs install && \
  echo "**** download jenkins ****" && \
  if [ -z ${JENKINS_VERSION} ]; then \
    JENKINS_VERSION=$(curl -sL https://api.github.com/repos/jenkinsci/jenkins/releases/latest | jq -r '.tag_name'); \
  fi && \
  mkdir -p \
    /app/jenkins/ && \
  curl -o \
    /app/jenkins/jenkins-plugin-manager.jar -L \
    "https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${PLUGIN_CLI_VERSION}/jenkins-plugin-manager-${PLUGIN_CLI_VERSION}.jar" && \
  curl -o \
    /app/jenkins/jenkins.war -L \
    "https://github.com/jenkinsci/jenkins/releases/download/${JENKINS_VERSION}/jenkins.war"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 50000 8080
VOLUME /config
