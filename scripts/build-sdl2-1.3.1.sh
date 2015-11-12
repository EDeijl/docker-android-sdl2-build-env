#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/set-env.sh
###################################################################################################

GHC="$HOME/.ghc/android-host/bin/ghc"

cd sdl2-1.3.1
arm-linux-androideabi-cabal install
