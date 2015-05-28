#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/set-env.sh
####################################################################################################

arm-linux-androideabi-cabal install \
  mtl-2.2.1 utf8-string-0.3.8 StateVar-1.0.0.0 random-1.1 utf8-string-0.3.8 MonadRandom-0.3 \
  control-monad-free-0.5.3 transformers-0.4.1.0

