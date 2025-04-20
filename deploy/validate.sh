#!/bin/bash
echo "[CD] Validating app..."
URL="http://localhost:8080/healthz"

for i in {1..10}; do
  RESPONSE=$(curl -s -w "HTTPSTATUS:%{http_code}" $URL)
  BODY=$(echo $RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
  STATUS=$(echo $RESPONSE | sed -e 's/.*HTTPSTATUS://')
  APP_STATUS=$(echo "$BODY" | grep -o '"status":"[^"]*"' | cut -d':' -f2 | tr -d '"')

  if [ "$STATUS" = "200" ] && [ "$APP_STATUS" = "UP" ]; then
    echo "[CD] ✅ Health check passed"
    exit 0
  fi
  sleep 3
done

echo "[CD] ❌ Health check failed: $BODY"
exit 1
