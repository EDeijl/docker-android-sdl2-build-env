FROM sseefried/debian-wheezy-ghc-android
MAINTAINER erik.deijl@gmail.com

USER androidbuilder
ENV BASE /home/androidbuilder/build
RUN mkdir -p $BASE
WORKDIR $BASE

#
# Install ant
#

USER root
run echo "deb http://ftp.nl.debian.org/debian wheezy main" > /etc/apt/sources.list
run echo "deb-src http://ftp.nl.debian.org/debian wheezy main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install ant openjdk-6-jdk -y
RUN wget http://dl.google.com/android/android-sdk_r24.2-linux.tgz
RUN cd .. && tar xzf build/android-sdk_r24.2-linux.tgz
RUN chown -R androidbuilder:androidbuilder /home/androidbuilder/android-sdk-linux

# Switch back to androidbuilder user
USER androidbuilder

#
# Add environment script
#
ADD scripts/set-env.sh $BASE/

#
# Install Android SDK platform tools, build tools and API
#
ADD scripts/install-android-sdk-platform-tools.sh $BASE/
RUN ./install-android-sdk-platform-tools.sh
ADD scripts/install-android-sdk-build-tools.sh $BASE/
RUN ./install-android-sdk-build-tools.sh
ADD scripts/install-android-api-12.sh $BASE/
RUN ./install-android-api-12.sh

#
# Build cpufeatures library
#
ADD scripts/build-cpufeatures.sh $BASE/
RUN ./build-cpufeatures.sh

#
# Build libpng
#

ADD scripts/download-libpng.sh $BASE/
RUN ./download-libpng.sh
ADD scripts/build-libpng.sh $BASE/
RUN ./build-libpng.sh

#
# Download SDL2 and SDL2_mixer
#
ADD scripts/clone-SDL2-mobile.sh $BASE/
RUN ./clone-SDL2-mobile.sh

#
# Build SDL2
#

ADD scripts/build-SDL2-mobile.sh $BASE/
RUN ./build-SDL2-mobile.sh

#
# Cabal install text-1.2.0.0
#

ADD scripts/cabal-install-text.sh $BASE/
RUN ./cabal-install-text.sh

#
# Cabal install vector-0.10.12.1
#

ADD scripts/cabal-install-vector.sh $BASE/
ADD scripts/vector-0.10.12.1.patch $BASE/
RUN ./cabal-install-vector.sh


#
# Add cabal setup wrapper
#

ADD scripts/arm-linux-androideabi-cabal-setup.sh /home/androidbuilder/.ghc/android-14/arm-linux-androideabi-4.8/bin/


ADD scripts/clone-hsSDL2.sh $BASE/
RUN ./clone-hsSDL2.sh
ADD scripts/build-hsSDL2.sh $BASE/
RUN ./build-hsSDL2.sh

#
# cabal install gtk2hs-buildtoosa (for host compiler)
#

ADD scripts/cabal-install-gtk2hs-buildtools.sh $BASE/
RUN ./cabal-install-gtk2hs-buildtools.sh

#
# Build OpenGLRaw
#

ADD scripts/clone-OpenGLRaw.sh $BASE/
RUN ./clone-OpenGLRaw.sh
ADD scripts/build-OpenGLRaw.sh $BASE/
RUN ./build-OpenGLRaw.sh

#
# Clone HXSDL
#
ADD scripts/clone-HXSDL.sh $BASE/
RUN ./clone-HXSDL.sh

#
# Clone android-build-HXSDL-apk
#
ADD scripts/clone-android-build-HXSDL-apk.sh $BASE/
RUN ./clone-android-build-HXSDL-apk.sh

