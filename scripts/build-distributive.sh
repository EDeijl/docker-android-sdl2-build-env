#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/set-env.sh
###################################################################################################

GHC="$HOME/.ghc/android-host/bin/ghc"

cd distributive-0.4.4
$GHC --make Setup.lhs
arm-linux-androideabi-cabal configure
cp Setup ./dist/setup/setup
arm-linux-androideabi-cabal install
