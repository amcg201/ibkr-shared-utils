#!/bin/bash

echo "🚀 Starting all IBKR bots and services at $(date)"

# === 1. Launch IB Gateway ===
open "/Users/aaronmcgilligan/Applications/IB Gateway 10.30/IB Gateway 10.30.app"
sleep 10  # Allow time to initialize visually

# === 1b. Wait until it's actually ready (up to 300s)
echo "⏳ Waiting for IB Gateway to become ready..."
/usr/local/bin/python3 "/Users/aaronmcgilligan/Documents/Trading Bots/Shared for IBKR/wait_for_ibgateway.py"

# === 2. Launch shared watchdog ===
/bin/bash "/Users/aaronmcgilligan/Documents/Trading Bots/Shared for IBKR/watchdog-ibgateway.sh" &

# === 3. Start Turtle Trading Bot immediately ===
/Library/Frameworks/Python.framework/Versions/3.13/bin/python3 \
"/Users/aaronmcgilligan/Documents/Trading Bots/Turtle-Trading-Bot/08_full_bot.py" \
>> "/Users/aaronmcgilligan/Documents/Trading Bots/Turtle-Trading-Bot/bot_output.log" 2>&1 &

# === 4. Start Forex Bot immediately ===
/Users/aaronmcgilligan/Documents/Trading\ Bots/forex-trading-bot/start-forex-bot.sh &

echo "✅ All bots and services launched at startup"

