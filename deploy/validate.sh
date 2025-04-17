#!/bin/bash
echo "[CD] Validating Spring Boot is running..."

HEALTH_CHECK_URL="http://localhost:8080/health"

RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" -X GET $HEALTH_CHECK_URL)

# 응답 추출
BODY=$(echo $RESPONSE | sed -e 's/HTTPSTATUS\:.*//g')
STATUS=$(echo $RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

if [ "$STATUS" -eq 200 ]; then
  echo "[CD] Health check passed."
  exit 0
else
  echo "[CD] Health check failed with status $STATUS"
  exit 1
fi
