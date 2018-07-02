#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# https://github.com/CryptoLions/scripts/
#
###############################################################################

CLEOS="/opt/EOS/bin/bin/cleos"

WALLETHOST="127.0.0.1"
WALLETPORT="9999"

NODEHOST="127.0.0.1"
NODEPORT="8888"

$CLEOS -u http://$NODEHOST:$NODEPORT --wallet-url http://$WALLETHOST:$WALLETPORT "$@"
