#!/bin/bash
echo "[CD] Stopping Spring Boot..."

PID=$(lsof -t -i:8080)

if [ -n "$PID" ]; then
  kill -9 $PID
  echo "[CD] Process $PID stopped."
else
  echo "[CD] No process running on port 8080."
fi