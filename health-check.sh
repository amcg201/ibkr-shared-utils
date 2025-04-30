#!/bin/bash

# Absolute paths
TURTLE_LOG="/Users/aaronmcgilligan/Documents/Trading Bots/Turtle-Trading-Bot/bot_output.log"
FOREX_LOG="/Users/aaronmcgilligan/Documents/Trading Bots/forex-trading-bot/forex-bot-cron.log"

TODAY=$(date "+%Y-%m-%d")

check_log() {
    local bot_name="$1"
    local log_file="$2"

    if [ ! -f "$log_file" ]; then
        echo "$bot_name log file missing!"
        return
    fi

    if ! grep -q "$TODAY" "$log_file"; then
        send_email "⚠️ $bot_name bot produced no output today."
    elif grep -qE "Traceback|Exception|Error" "$log_file"; then
        send_email "🚨 $bot_name bot error detected in log. Check immediately."
    fi
}

send_email() {
    local message="$1"

    /usr/local/bin/python3 -c "
from email.message import EmailMessage
import smtplib
msg = EmailMessage()
msg.set_content('$message')
msg['Subject'] = 'Bot Monitor Alert'
msg['From'] = 'amcg20@gmail.com'
msg['To'] = 'amcg20@gmail.com'
server = smtplib.SMTP('smtp.gmail.com', 587)
server.starttls()
server.login('amcg20@gmail.com', 'wadklbqbvttiyqih')
server.send_message(msg)
server.quit()
"
}

check_log "Turtle" "$TURTLE_LOG"
check_log "Forex" "$FOREX_LOG"
