#!/bin/bash

# === Shared IB Gateway Watchdog ===
# Monitors and restarts IB Gateway if it's not running

APP_PATH="/Users/aaronmcgilligan/Applications/IB Gateway 10.30/IB Gateway 10.30.app"
LOG_FILE="/Users/aaronmcgilligan/Documents/Trading Bots/Shared for IBKR/watchdog.log"
LOCK_FILE="/tmp/ibgateway_watchdog.lock"
CHECK_INTERVAL=60
MAX_LOG_SIZE_KB=1000

# --- Lockfile protection ---
if [ -f "$LOCK_FILE" ]; then
    echo "🚫 Watchdog already running (lock exists). Exiting."
    exit 1
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

echo "🕵️ Watchdog started at $(date)" >> "$LOG_FILE"

# --- Check loop ---
while true; do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    # --- Truncate log if too big ---
    if [ -f "$LOG_FILE" ]; then
        LOG_SIZE_KB=$(du -k "$LOG_FILE" | cut -f1)
        if [ "$LOG_SIZE_KB" -gt "$MAX_LOG_SIZE_KB" ]; then
            echo "$TIMESTAMP - 🧹 Truncating log (exceeded ${MAX_LOG_SIZE_KB}KB)" > "$LOG_FILE"
        fi
    fi

    # --- Check if IB Gateway is running ---
    if ! pgrep -f "IB Gateway 10.30" > /dev/null; then
        echo "$TIMESTAMP - ❌ IB Gateway not running. Restarting..." >> "$LOG_FILE"
        open "$APP_PATH"
        sleep 10
    else
        echo "$TIMESTAMP - ✅ IB Gateway running fine." >> "$LOG_FILE"
    fi

    sleep $CHECK_INTERVAL
done

