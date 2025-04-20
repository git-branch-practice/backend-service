#!/bin/bash
echo "[CD] Validating Spring Boot is running..."

HEALTH_CHECK_URL="http://localhost:8080/healthz"
sleep 3  # 서버 기동 시간 고려

RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" -X GET $HEALTH_CHECK_URL)

# 본문과 상태코드 분리
BODY=$(echo $RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
STATUS=$(echo $RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

APP_STATUS=$(echo "$BODY" | grep -o '"status":"[^"]*"' | cut -d':' -f2 | tr -d '"')

if [ "$STATUS" -eq 200 ] && [ "$APP_STATUS" = "UP" ]; then
  echo "[CD] ✅ Health check passed. (App Status: $APP_STATUS)"
  exit 0
else
  echo "[CD] ❌ Health check failed. (HTTP $STATUS, App Status: $APP_STATUS)"
  echo "Response Body: $BODY"
  exit 1
fi