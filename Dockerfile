# https://github.com/jk2K/gitlab-ci-android

FROM openjdk:8-jdk-alpine
MAINTAINER jk2K <jk2K.com>

ENV VERSION_SDK_TOOLS "25.1.7"
ENV VERSION_BUILD_TOOLS "24"
ENV VERSION_TARGET_SDK "24"

ENV SDK_PACKAGES "build-tools-${VERSION_BUILD_TOOLS},android-${VERSION_TARGET_SDK},addon-google_apis-google-${VERSION_TARGET_SDK},platform-tools,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"

RUN apk add --no-cache \
    curl \
    ca-certificates \
    bash \
    libstdc++ \
    unzip

ADD http://dl.google.com/android/repository/tools_r${VERSION_SDK_TOOLS}-linux.zip /tools.zip
RUN unzip /tools.zip -d /sdk && \
    rm -v /tools.zip
RUN echo y | android update sdk -u -a -t ${SDK_PACKAGES}
