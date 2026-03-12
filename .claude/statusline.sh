#!/bin/bash
# Statusline: context window % + real 5hr/weekly usage from Anthropic API
input=$(cat)

# Extract context window percentage and model
MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
CTX_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | xargs printf "%.0f")

# Color helper: green < 30, yellow 30-70, red > 70
color_pct() {
  local pct=$1 label=$2
  if [ "$pct" -lt 30 ] 2>/dev/null; then
    printf '\033[32m%s:%s%%\033[0m' "$label" "$pct"
  elif [ "$pct" -lt 70 ] 2>/dev/null; then
    printf '\033[33m%s:%s%%\033[0m' "$label" "$pct"
  else
    printf '\033[31m%s:%s%%\033[0m' "$label" "$pct"
  fi
}

CTX=$(color_pct "$CTX_PCT" "Ctx")

# Cache file for usage API responses
CACHE_FILE="/tmp/.claude-usage-cache"
CACHE_TTL=300
LOCK_FILE="/tmp/.claude-usage-fetch.lock"
NOW_EPOCH=$(date +%s)
USAGE_JSON=""

# Always read cache first (even if stale — we'll refresh in background)
if [ -f "$CACHE_FILE" ]; then
  USAGE_JSON=$(cat "$CACHE_FILE" 2>/dev/null)
fi

# Check if cache is stale and kick off background refresh
if [ -f "$CACHE_FILE" ]; then
  CACHE_AGE=$(( NOW_EPOCH - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0) ))
else
  CACHE_AGE=$((CACHE_TTL + 1))
fi

if [ "$CACHE_AGE" -ge "$CACHE_TTL" ]; then
  # Only start one background fetch at a time (use lock file with 60s staleness)
  if ( set -o noclobber; echo $$ > "$LOCK_FILE" ) 2>/dev/null || \
     [ "$(( NOW_EPOCH - $(stat -c %Y "$LOCK_FILE" 2>/dev/null || echo 0) ))" -gt 60 ]; then
    (
      TOKEN=$(jq -r '.claudeAiOauth.accessToken' /home/neil/.claude/.credentials.json 2>/dev/null)
      if [ -n "$TOKEN" ] && [ "$TOKEN" != "null" ]; then
        FETCHED=$(curl -s --max-time 15 "https://api.anthropic.com/api/oauth/usage" \
          -H "Accept: application/json" \
          -H "Authorization: Bearer $TOKEN" \
          -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)
        if echo "$FETCHED" | jq -e '.five_hour or .seven_day' >/dev/null 2>&1; then
          echo "$FETCHED" > "$CACHE_FILE"
        fi
      fi
      rm -f "$LOCK_FILE"
    ) &
    disown
  fi
fi

# utilization values from the API are already percentages (e.g. 22.0)
pct_int() {
  local raw=$1
  if [ -z "$raw" ]; then echo ""; return; fi
  printf "%.0f" "$raw" 2>/dev/null || echo ""
}

time_until() {
  local reset_at=$1
  if [ -n "$reset_at" ]; then
    local epoch
    epoch=$(date -d "$reset_at" +%s 2>/dev/null)
    if [ -n "$epoch" ] && [ "$epoch" -gt "$NOW_EPOCH" ]; then
      local diff=$((epoch - NOW_EPOCH))
      local h=$((diff / 3600))
      local m=$(( (diff % 3600) / 60 ))
      if [ "$h" -ge 24 ]; then
        local d=$((h / 24))
        h=$((h % 24))
        echo "${d}d${h}h"
      elif [ "$h" -gt 0 ]; then
        echo "${h}h${m}m"
      else
        echo "${m}m"
      fi
      return
    fi
  fi
  echo ""
}

if [ -n "$USAGE_JSON" ]; then
  FIVE_HR=$(pct_int "$(echo "$USAGE_JSON" | jq -r '.five_hour.utilization // empty' 2>/dev/null)")
  SEVEN_DAY=$(pct_int "$(echo "$USAGE_JSON" | jq -r '.seven_day.utilization // empty' 2>/dev/null)")

  if [ -n "$FIVE_HR" ] && [ -n "$SEVEN_DAY" ]; then
    FIVE=$(color_pct "$FIVE_HR" "5h")
    WEEK=$(color_pct "$SEVEN_DAY" "Wk")

    FIVE_RESET=$(time_until "$(echo "$USAGE_JSON" | jq -r '.five_hour.resets_at // empty' 2>/dev/null)")
    WEEK_RESET=$(time_until "$(echo "$USAGE_JSON" | jq -r '.seven_day.resets_at // empty' 2>/dev/null)")

    TIMERS=""
    [ -n "$FIVE_RESET" ] && TIMERS="5h:${FIVE_RESET}"
    [ -n "$WEEK_RESET" ] && TIMERS="${TIMERS:+$TIMERS }Wk:${WEEK_RESET}"
    [ -n "$TIMERS" ] && TIMERS=" | $TIMERS"

    echo -e "[$MODEL] $CTX | $FIVE | $WEEK$TIMERS"
  else
    echo -e "[$MODEL] $CTX"
  fi
else
  echo -e "[$MODEL] $CTX"
fi
