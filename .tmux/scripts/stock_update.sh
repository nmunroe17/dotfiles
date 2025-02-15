#!/bin/bash
while true; do
    curl -s "https://query1.finance.yahoo.com/v8/finance/chart/AAPL?interval=1d" | \
    jq -r '.chart.result[0].meta.regularMarketPrice' > /tmp/stock_price 2>/dev/null || echo "---" > /tmp/stock_price
    sleep 300  # Update every 5 minutes
done
