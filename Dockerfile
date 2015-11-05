FROM edeijl/ghc-android
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
# Add cabal setup wrapper
#

ADD scripts/arm-linux-androideabi-cabal-setup.sh /home/androidbuilder/.ghc/android-14/arm-linux-androideabi-4.8/bin/

#
# SDL dependencies
#
ADD scripts/update-cabal.sh $BASE/
RUN ./update-cabal.sh
#ADD scripts/get-bytes.sh $BASE/
#RUN ./get-bytes.sh
#ADD scripts/build-bytes.sh $BASE/
#RUN ./build-bytes.sh
#ADD scripts/get-distributive.sh $BASE/
#RUN ./get-distributive.sh
#ADD scripts/build-distributive.sh $BASE/
#RUN ./build-distributive.sh
#ADD scripts/get-comonad.sh $BASE/
#RUN ./get-comonad.sh
#ADD scripts/build-comonad.sh $BASE/
#RUN ./build-comonad.sh
#ADD scripts/get-reflection.sh $BASE/
#RUN ./get-reflection.sh
#ADD scripts/build-reflection.sh $BASE/
#RUN ./build-reflection.sh
#ADD scripts/get-semigroupoids.sh $BASE/
#RUN ./get-semigroupoids.sh
#ADD scripts/build-semigroupoids.sh $BASE/
#RUN ./build-semigroupoids.sh
#ADD scripts/get-lens.sh $BASE/
#RUN ./get-lens.sh
#ADD scripts/build-lens.sh $BASE/
#RUN ./build-lens.sh
#ADD scripts/get-linear.sh $BASE/
#RUN ./get-linear.sh
#ADD scripts/build-linear.sh $BASE/
#RUN ./build-linear.sh

#
# Clone & build hsSDL2
#

#ADD scripts/clone-hsSDL2.sh $BASE/
#RUN ./clone-hsSDL2.sh
#ADD scripts/build-hsSDL2.sh $BASE/
#RUN ./build-hsSDL2.sh
#
##
## Clone & build hs-sdl2-mixer
##
#
#ADD scripts/clone-hs-sdl2-mixer.sh $BASE/
#RUN ./clone-hs-sdl2-mixer.sh
#ADD scripts/build-hs-sdl2-mixer.sh $BASE/
#RUN ./build-hs-sdl2-mixer.sh
#
#
##
## cabal install gtk2hs-buildtoosa (for host compiler)
##
#
#ADD scripts/cabal-install-gtk2hs-buildtools.sh $BASE/
#RUN ./cabal-install-gtk2hs-buildtools.sh
#
##
## Build all epidemic dependencies
##
#
#ADD scripts/cabal-install-hs-cairo-dependencies.sh $BASE/
#RUN ./cabal-install-hs-cairo-dependencies.sh
#
##
## Build Cairo Haskell binding
##
#
#ADD scripts/clone-hs-cairo.sh $BASE/
#RUN ./clone-hs-cairo.sh
#ADD scripts/build-hs-cairo.sh $BASE/
#RUN ./build-hs-cairo.sh
#
##
## Build Haskell Chipmunk binding, Hipmunk
##
#
#ADD scripts/clone-Hipmunk.sh $BASE/
#RUN ./clone-Hipmunk.sh
#ADD scripts/build-Hipmunk.sh $BASE/
#RUN ./build-Hipmunk.sh
#
##
## Build OpenGLRaw
##
#
#ADD scripts/clone-OpenGLRaw.sh $BASE/
#RUN ./clone-OpenGLRaw.sh
#ADD scripts/build-OpenGLRaw.sh $BASE/
#RUN ./build-OpenGLRaw.sh
#
##
## Clone Epidemic
##
#
#ADD scripts/clone-epidemic-game.sh $BASE/
#RUN ./clone-epidemic-game.sh
#
##
## Clone android-build-epidemic-apk
##
#
#ADD scripts/clone-android-build-epidemic-apk.sh $BASE/
#RUN ./clone-android-build-epidemic-apk.sh
