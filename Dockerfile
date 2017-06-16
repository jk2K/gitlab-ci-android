FROM openjdk:8-jdk
MAINTAINER jk2K <https://github.com/jk2K/gitlab-ci-android>

ENV VERSION_SDK_TOOLS "25.2.2"
ENV VERSION_BUILD_TOOLS "25.0.3"
ENV VERSION_TARGET_SDK "25"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"

# Install required tools
RUN apt-get -qq update && \
    apt-get install -qqy --no-install-recommends \
    curl \
    lib32stdc++6 \
    lib32z1 \
    unzip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Accept "android-sdk-license" before installing components, no need to echo y for each component
# License is valid for all the standard components in versions installed from this file
RUN mkdir -p $ANDROID_HOME/licenses/ \
    && echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license

# Download Android SDK tools into $ANDROID_HOME
ADD https://dl.google.com/android/repository/tools_r25.2.5-linux.zip /android-sdk-tools.zip
RUN unzip /android-sdk-tools.zip -d /sdk && \
    rm -v /android-sdk-tools.zip

# Platform tools
RUN sdkmanager "platform-tools"

# Tools
RUN sdkmanager "tools"

# SDKs
# Please keep these in descending order!
RUN sdkmanager "platforms;android-${VERSION_TARGET_SDK}"

# build tools
# Please keep these in descending order!
RUN sdkmanager "build-tools;${VERSION_BUILD_TOOLS}"

# Extras
RUN sdkmanager "extras;android;m2repository"
RUN sdkmanager "extras;google;m2repository"
RUN sdkmanager "extras;google;google_play_services"

# Cleaning
RUN apt-get clean
