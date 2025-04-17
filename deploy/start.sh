#!/bin/bash
echo "[CD] Start Spring Boot Server..."

# 실행 중인 프로세스가 있다면 종료 (예: port 8080)
PID=$(lsof -t -i:8080)
if [ -n "$PID" ]; then
  echo "[CD] Stopping existing process on port 8080..."
  kill -9 $PID
fi

# JAR 실행
JAR_PATH=$(find ../backend/build/libs -name "*.jar" | head -n 1)

echo "[CD] Running $JAR_PATH"
nohup java -jar "$JAR_PATH" > spring.log 2>&1 &

echo "[CD] Spring Boot started."
