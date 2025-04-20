#!/bin/bash
echo "[CD] Start Spring Boot Server..."

# 실행 중인 프로세스가 있다면 종료 (예: port 8080)
PID=$(lsof -t -i:8080)
if [ -n "$PID" ]; then
  echo "[CD] Stopping existing process on port 8080..."
  kill -9 $PID
fi

# JAR 실행 (복사된 ~/deploy 경로 기준)
JAR_PATH=$(ls -t ~/deploy/backend/*.jar | head -n 1)

if [ -z "$JAR_PATH" ]; then
  echo "[CD] ❌ No JAR file found to execute."
  exit 1
fi

echo "[CD] Running $JAR_PATH"
nohup java -jar "$JAR_PATH" > ~/deploy/spring.log 2>&1 &

echo "[CD] Spring Boot started."