#!/bin/bash

echo "🚀 Starting all IBKR bots and services at $(date)"

# === 1. Launch IB Gateway ===
open "/Users/aaronmcgilligan/Applications/IB Gateway 10.30/IB Gateway 10.30.app"
sleep 10  # allow time to initialize

# === 2. Launch shared watchdog ===
/bin/bash "/Users/aaronmcgilligan/Documents/Trading Bots/Shared for IBKR/watchdog-ibgateway.sh" &

# === 3. Start Turtle Trading Bot immediately ===
/Library/Frameworks/Python.framework/Versions/3.13/bin/python3 \
"/Users/aaronmcgilligan/Documents/Trading Bots/Turtle-Trading-Bot/08_full_bot.py" \
>> "/Users/aaronmcgilligan/Documents/Trading Bots/Turtle-Trading-Bot/bot_output.log" 2>&1 &

# === 4. Start Forex Bot immediately ===
/Users/aaronmcgilligan/Documents/Trading\ Bots/forex-trading-bot/start-forex-bot.sh \
>> "/Users/aaronmcgilligan/Documents/Trading Bots/forex-trading-bot/forex-bot-cron.log" 2>&1 &

echo "✅ All bots and services launched at startup"
