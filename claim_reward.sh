#!/bin/bash
################################################################################
#
# Scrip Created by http://CryptoLions.io
# Claim Rewards Bot
#
# Claims each 24h+1min, sends telegram report and saves all into log.
#
# Edit config.json with your data and run start.sh to run bot in background
# !!! Compile claim_reward.sh to claim_reward using shc (readme)  or edit line 34
#
# https://github.com/CryptoLions/
#
################################################################################

./cleos.sh wallet unlock --password XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > /dev/null 2> /dev/null
./cleos.sh system claimrewards $1 -p $1 -j
./cleos.sh wallet lock > /dev/null 2> /dev/null
