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

DATADIR="./"

./stop.sh
./bot.sh  > $DATADIR/claimbot_out.log 2> $DATADIR/claimbot_err.log &  echo $! > $DATADIR/claimbot.pid

