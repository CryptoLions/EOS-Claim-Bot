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

config="config.json"
BP_NAME="$( jq -r '.BP_NAME' "$config" )";
CLAIM_INTERVAL="$( jq -r '.CLAIM_INTERVAL' "$config" )";
TELEGRAM_BOT_ID="$( jq -r '.TELEGRAM_BOT_ID' "$config" )";
TELEGRAM_CHAT_IDS=($( jq -r '.TELEGRAM_CHAT_IDS' "$config" ));

TELEGRAM_API="https://api.telegram.org/bot";
TELEGRAM_SEND_MSG=$TELEGRAM_API$TELEGRAM_BOT_ID"/sendMessage";

getLastClaim(){
    LAST_CLAIM_TIME=$(./cleos.sh system listproducers -l 100 -j | jq -r '.rows[] | select(.owner == "'$BP_NAME'") | .last_claim_time')   #'
    
    LAST_CLAIM_TIME=$(date -d $LAST_CLAIM_TIME +"%s")
    return $LAST_CLAIM_TIME
}


claim_reward(){
    CLAIM=$(./claim_reward $BP_NAME 2>stderr.txt)

    ERR=$(cat stderr.txt)
    rm stderr.txt
    #CLAIM=$(cat claim)
    echo "CLAIN REWARD $(date)" >> log.txt
    echo "--stdout-----------------------" >> log.txt
    echo $CLAIM  >> log.txt
    echo "--stderr-----------------------" >> log.txt
    echo $ERR >> log.txt
    echo "-------------------------" >> log.txt

    if [[ "$ERR" == *"Error"* && "$CLAIM" == "" ]]; then
	#claim error
	sendmessage "Error on claim. Will try again in 2 min..."
	sleep 120
	claim_reward "";
	return
    fi

    TXID=$(echo "${CLAIM}" | jq -r '.transaction_id');
    TOTAL=0
    OUTPUT="";
    for row in $(echo "${CLAIM}" | jq -r '.processed.action_traces[0].inline_traces[] | @base64'); do
	_jq() {
    	    echo ${row} | base64 --decode | jq -r ${1}
	}
	sub_json=$(_jq '.')

	for row in $(echo "${sub_json}" | jq -r '.inline_traces[] | @base64'); do
	    _jq() {
    		echo ${row} | base64 --decode | jq -r ${1}
	    }
	    receiver=$(_jq '.receipt.receiver')
	    if [[ "$receiver" == "$BP_NAME" ]]; then
		TO=$(_jq '.act.data.to');
		QUANTITY=$(_jq '.act.data.quantity');
		FROM=$(_jq '.act.data.from');
		MEMO=$(_jq '.act.data.memo');

		AMOUNT_A=($QUANTITY)
		AMOUNT_=${AMOUNT_A[0]}
		AMOUNT=${AMOUNT_//\./}

		#TOTAL=$(echo "$TOTAL+$AMOUNT" | bc)
		TOTAL=$(($TOTAL+$AMOUNT))

	        #TOTAL=$(($TOTAL+$((${AMOUNT[0]}*1000))));
	        if [ "$OUTPUT" != "" ]; then
	    	    OUTPUT="$OUTPUT----------\n";
		fi
	        OUTPUT="$OUTPUT<b>From: </b> $FROM \n";
	        OUTPUT="$OUTPUT<b>To: </b> $TO \n";
	        OUTPUT="$OUTPUT<b>Quantity: </b> $QUANTITY \n";
	        OUTPUT="$OUTPUT<b>Memo: </b> $MEMO \n";
	    fi
	done

    done

	OUTPUT="💰<b>CLAIM REWARD:</b> $(date) \n <b>TX ID:</b> $TXID \n\n$OUTPUT";
	OUTPUT="$OUTPUT<b>================== </b> \n";
	OUTPUT="$OUTPUT<b>Total:</b> $( echo "scale=4; $TOTAL/10000" | bc -l) EOS \n";


	sendmessage "$OUTPUT"
	echo -ne $OUTPUT >> log.txt
	
	echo "waiting new claim..."
	sleep $CLAIM_INTERVAL
	claim_reward ""
	

}
sendmessage(){

    msg=$1
    for i in "${TELEGRAM_CHAT_IDS[@]}"
    do
	curl --data chat_id="$i" --data-urlencode "text=$(echo -ne $msg)" "$TELEGRAM_SEND_MSG?parse_mode=html" >/dev/null 2>/dev/null
    done
}


getLastClaim ""
now=`(date +%s)`

if [ $(($now-$LAST_CLAIM_TIME)) -lt $CLAIM_INTERVAL ]; then
    waitt=$(($CLAIM_INTERVAL - $now + $LAST_CLAIM_TIME));
    wait_min=$((waitt/60));
    echo "wait to claim: $wait_min min"
    sendmessage "⚡️ Claim Bot started. Next Claim in: $wait_min  min"
    sleep $waitt;
    claim_reward ""

else
    echo "It's Time to claimreward."
    claim_reward ""
fi

