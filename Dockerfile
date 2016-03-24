FROM ubuntu:latest
MAINTAINER FlexConstructor <flexconstructor@gmail.com>
USER root

#=======================
# Enveronment variables.
#=======================

ENV JAVA_HOME              /usr/lib/jvm/java-8-oracle
ENV ANT_VERSION            1.9.6
ENV FLASH_DIR              /opt/flash
ENV ANT_HOME               /opt/ant
ENV PATH                   ${PATH}:${ANT_HOME}/bin
ENV JAVA_OPTS              -Djava.awt.headless=true
ENV FLASHPLAYER_DEBUGGER   /usr/lib/flashplayer/flashplayerdebugger
ENV AIR_HOME               /opt/flash/AdobeAIRSDK
ENV PLAYERGLOBAL_HOME      /opt/flash/player
ENV TLF_HOME               /opt/flash/flex-tlf
ENV FLEX_HOME              /opt/flash/flex-sdk
ENV FLEX_UNIT_HOME         /opt/flash/flexunit/bin

#=======================
# Install java.
#=======================

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && apt-get -y install \
    && apt-get -y upgrade && apt-get -y install ntp software-properties-common \
    && echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \
    && apt-get -y update \
    && apt-get -y install oracle-java8-installer \
    && apt-get -y install  oracle-java8-set-default

#=======================
# Install ant.
#=======================

RUN cd && wget -q http://www.eu.apache.org/dist//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && tar xzf apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mv apache-ant-${ANT_VERSION} /opt/ant \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz

#=======================
# Install gradle.
#=======================

 RUN add-apt-repository ppa:cwchien/gradle \
     && apt-get update \
     && apt-get -y install gradle

#=======================
# Install Xvfb.
#=======================

RUN apt-get update \
    && apt-get install  -y aptitude wget git libxtst-dev libxrender-dev \
    && aptitude install -y xvfb \
    && aptitude install -y x11-xkb-utils \
    && aptitude install -y xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic \
    && aptitude install -y xserver-xorg-core

#=======================
# Install flash player.
#=======================

RUN mkdir -p $FLASH_DIR
WORKDIR $FLASH_DIR

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y libcurl3:i386 libglib2.0-0:i386 libx11-6:i386 libxext6:i386 libxcursor1:i386 libnss3:i386 libgtk2.0-0:i386 libXtst6:i386 libXi6:i386

RUN wget https://fpdownload.macromedia.com/pub/flashplayer/updaters/11/flashplayer_11_sa_debug.i386.tar.gz \
    && tar xvzf flashplayer_11_sa_debug.i386.tar.gz \
    && rm flashplayer_11_sa_debug.i386.tar.gz \
    && mkdir -p /usr/lib/flashplayer \
    && mv flashplayerdebugger /usr/lib/flashplayer/flashplayerdebugger \
    && rm -rf /usr/bin/flashplayerdebugger \
    && ln -s /usr/lib/flashplayer/flashplayerdebugger /usr/bin/flashplayerdebugger

#=======================
# Install AIR SDK.
#=======================

RUN wget http://airdownload.adobe.com/air/mac/download/latest/AdobeAIRSDK.tbz2 \
    && mkdir -p /opt/flash/AdobeAIRSDK \
    && tar -jxvf AdobeAIRSDK.tbz2 -C /opt/flash/AdobeAIRSDK \
    && rm -rf AdobeAIRSDK.tbz2

#==========================
# Install playerglobal.swc.
#==========================

RUN git clone -b develop https://github.com/apache/flex-sdk.git \
    && mkdir -p /opt/flash/player/11.1 \
    && wget http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_1.swc -O /opt/flash/player/11.1/playerglobal.swc

#==========================
# Download Flex-TLF.
#==========================

RUN git clone -b develop https://git-wip-us.apache.org/repos/asf/flex-tlf.git flex-tlf

#==========================
# Download Flex-Unit.
#==========================

RUN git clone -b develop https://git-wip-us.apache.org/repos/asf/flex-flexunit.git flexunit

#==========================
# Install FlexSDK.
#==========================

WORKDIR $FLEX_HOME
RUN ant main -Dbuild.noprompt=true -Djava.awt.headless=true

#==========================
# Install FlexUnit.
#==========================

WORKDIR ${FLASH_DIR}/flexunit
RUN ant thirdparty-downloads  -Dbuild.noprompt=true -Djava.awt.headless=true
RUN ant -Dbuild.noprompt=true -Djava.awt.headless=true
RUN mkdir -p bin \
    && cp FlexUnit4/target/*flex*.swc bin \
    && cp FlexUnit4AirCIListener/target/*.swc bin \
    && cp FlexUnit4AntTasks/target/*.jar bin \
    && cp FlexUnit4CIListener/target/*.swc bin \
    && cp FlexUnit4FlexCoverListener/target/*.swc bin \
    && cp FlexUnit4FluintExtensions/target/*.swc bin \
    && cp FlexUnit4UIListener/target/*.swc bin

#==========================
# Configure run.
#==========================

RUN mkdir workspace
WORKDIR /opt/flash/workspace
VOLUME /opt/flash/workspace
ENTRYPOINT ["gradle"]
CMD ["clean", "build","test"]

