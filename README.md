# EOS-Claim-Bot
claim rewards bot + Telegram and log report

1. Copy config.json.default to config.json and edit with your data (how to create bot and get chat ID check below)  
2. Edit cleos.sh  
3. Edit claim_reward.sh with your wallet password (wallet should have producer key imported)
4. Compile and obfuscate claim_reward.sh to claim_reward using shc (If you dont have you need to install it somevere https://github.com/neurobin/shc)  
    ```
    shc -U -f claim_reward.sh -o claim_reward
    ```
5. Run start.sh to start bot in background.

# Telegram Bot and chat_ids  
You need to create Telegram bot before: @BotFather  
First you need register a bot. You will receive BOT_ID. Open your bot and send first /start  
visit url to get user ids:  
https://api.telegram.org/botBOT_ID/getUpdates  
where BOT_ID is your bot id received on bot registration  
