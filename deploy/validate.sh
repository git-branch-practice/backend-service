#!/bin/bash
echo "[CD] Validating Spring Boot is running..."

HEALTH_CHECK_URL="http://localhost:8080"
sleep 3  # 서버 기동 시간 고려

RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" -X GET $HEALTH_CHECK_URL)

# 본문과 상태코드 분리
BODY=$(echo $RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
STATUS=$(echo $RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

if [ "$STATUS" -eq 200 ]; then
  echo "[CD] ✅ Health check passed."
  exit 0
else
  echo "[CD] ❌ Health check failed with status $STATUS"
  exit 1
fi
