FROM centos:latest
MAINTAINER FlexConstructor <flexconstructor@gmail.com>


#=======================
# Enveronment variables.
#=======================

ENV GRADLE_VERSION         2.12
ENV FLEX_SDK_VERSION       4.15.0
ENV JDK_URL                http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz
ENV JAVA_VERSION           1.8.0
ENV JAVA_HOME              /opt/java
ENV ANT_VERSION            1.9.6
ENV FLASH_DIR              /opt/flash
ENV ANT_HOME               /opt/ant
ENV GRADLE_HOME            /opt/gradle/gradle-${GRADLE_VERSION}
ENV PATH                   ${PATH}:${JAVA_HOME}/bin:${ANT_HOME}/bin:${GRADLE_HOME}/bin
ENV JAVA_OPTS              -Djava.awt.headless=true
ENV PLAYERGLOBAL_HOME      /opt/flash/player
ENV FLEX_HOME              /opt/flash/flex-sdk/apache-flex-sdk-${FLEX_SDK_VERSION}-bin
ENV FLEX_UNIT_HOME         /opt/flash/flexunit/bin
ENV FLASH_PLAYER_EXE       /usr/bin/gflashplayer

#=======================
# Install dependencies.
#=======================

RUN    yum -y update \
    && yum install -y    wget \
                      openssl \
              ca-certificates \
                          tar \
                        unzip \
                 libcurl.i686 \
                  libcurl-dev \
                 libcurl curl \
    libcanberra-gtk-module.so \
          libpk-gtk-module.so \
                   libssl3.so \
          libgtk-x11-2.0.so.0 \
           libfontconfig.so.1 \
             libfreetype.so.6 \
                   libXt.so.6 \
                 libXext.so.6 \
                  libX11.so.6 \
            gtk2-engines.i686 \
                        which \
         xorg-x11-server-Xvfb \
                          git \
                        bzip2 \
    && yum clean all          \

#=======================
# Install java.
#=======================

    && cd /tmp                                                                    \
    && wget -qO jdk8.tar.gz                                                       \
            --header "Cookie: oraclelicense=accept-securebackup-cookie"           \
            $JDK_URL                                                              \
    && tar xzf jdk8.tar.gz -C /opt                                                \
    && mv /opt/jdk* /opt/java                                                     \
    && rm /tmp/jdk8.tar.gz                                                        \
    && update-alternatives --install /usr/bin/java java /opt/java/bin/java 100    \
    && update-alternatives --install /usr/bin/javac javac /opt/java/bin/javac 100 \

#=======================
# Install ant.
#=======================

    && cd && wget -q http://www.eu.apache.org/dist//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && tar xzf apache-ant-${ANT_VERSION}-bin.tar.gz                                                   \
    && mv apache-ant-${ANT_VERSION} /opt/ant                                                          \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz                                                     \

#=======================
# Install gradle.
#=======================

    && mkdir /opt/gradle                                                                 \
    && wget -N http://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip \
    && unzip -oq ./gradle-${GRADLE_VERSION}-all.zip -d /opt/gradle                       \
    && rm ./gradle-${GRADLE_VERSION}-all.zip                                             \

#=======================
# Install flash player.
#=======================

    && mkdir -p $FLASH_DIR                                                                                    \
    && cd $FLASH_DIR                                                                                          \
    && wget https://fpdownload.macromedia.com/pub/flashplayer/updaters/11/flashplayer_11_sa_debug.i386.tar.gz \
    && tar xvzf flashplayer_11_sa_debug.i386.tar.gz                                                           \
    && rm flashplayer_11_sa_debug.i386.tar.gz                                                                 \
    && mkdir -p /usr/lib/flashplayer                                                                          \
    && mv flashplayerdebugger /usr/lib/flashplayer/flashplayerdebugger                                        \
    && rm -rf /usr/bin/flashplayerdebugger                                                                    \
    && ln -s /usr/lib/flashplayer/flashplayerdebugger /usr/bin/gflashplayer                                   \

#==========================
# Download Flex-Unit.
#==========================

    && git clone -b develop https://git-wip-us.apache.org/repos/asf/flex-flexunit.git flexunit \

#==========================
# Install FlexSDK.
#==========================

&& wget http://apache.cbox.biz/flex/4.15.0/binaries/apache-flex-sdk-${FLEX_SDK_VERSION}-bin.tar.gz \
    && mkdir -p /opt/flash/flex-sdk                                                                \
&& tar zxvf apache-flex-sdk-${FLEX_SDK_VERSION}-bin.tar.gz -C /opt/flash/flex-sdk                  \
&& rm apache-flex-sdk-${FLEX_SDK_VERSION}-bin.tar.gz                                               \
    && cd $FLEX_HOME                                                                               \
    && ant -f installer.xml -Dair.sdk.version=2.6                                                  \
                            -Djava.awt.headless=true                                               \
                            -Dinput.air.download=y                                                 \
                            -Dinput.fontswf.download=y                                             \
                            -Dinput.flash.download=y                                               \

#==========================
# Install playerglobal.swc.
#==========================

     && mkdir -p ${FLEX_HOME}/frameworks/libs/player/11.1                                       \
     && wget http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_1.swc -O \
             ${FLEX_HOME}/frameworks/libs/player/11.1/playerglobal.swc                          \

#==========================
# Install FlexUnit.
#==========================


    && cd ${FLASH_DIR}/flexunit                                                 \
    && ant thirdparty-downloads  -Dbuild.noprompt=true -Djava.awt.headless=true \
    && ant -Dbuild.noprompt=true -Djava.awt.headless=true                       \
    && mkdir -p bin                                                             \
    && cp FlexUnit4/target/*flex*.swc bin                                       \
    && cp FlexUnit4AirCIListener/target/*.swc bin                               \
    && cp FlexUnit4AntTasks/target/*.jar bin                                    \
    && cp FlexUnit4CIListener/target/*.swc bin                                  \
    && cp FlexUnit4FlexCoverListener/target/*.swc bin                           \
    && cp FlexUnit4FluintExtensions/target/*.swc bin                            \
    && cp FlexUnit4UIListener/target/*.swc bin                                  \

#==========================
# Configure run.
#==========================
    && mkdir ${FLASH_DIR}/workspace \
    && mkdir /opt/bin

#==========================
# Test flex unit.
#==========================

ENV DISPLAY                :99.0

RUN cd ${FLASH_DIR}/flexunit \
&& xvfb-run -e /dev/stdout --server-args="$DISPLAY -screen 0 700x500x24 -ac +extension RANDR" ant test -Dbuild.noprompt=true -Djava.awt.headless=true

COPY run.sh /opt/bin/run.sh
RUN chmod +x /opt/bin/run.sh
VOLUME       ${FLASH_DIR}/workspace
CMD ["/opt/bin/run.sh"]