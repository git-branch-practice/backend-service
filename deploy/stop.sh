#!/bin/bash
echo "[CD] Stopping Spring Boot..."
PID=$(lsof -t -i:8080)
[ -n "$PID" ] && kill -9 $PID && echo "[CD] Killed PID $PID"
