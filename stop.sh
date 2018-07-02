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

DIR="./"


    if [ -f $DIR"/claimbot.pid" ]; then
	pid=`cat $DIR"/claimbot.pid"`
	echo $pid
	kill $pid
	rm -r $DIR"/claimbot.pid"
	
	echo -ne "Stoping Daemon"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
        echo -ne "\rDaemon Stopped.    \n"
    fi

