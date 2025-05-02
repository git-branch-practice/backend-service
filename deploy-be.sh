#!/bin/bash
set -euo pipefail

echo "🚀 [START] 백엔드 서비스(Spring Boot) 배포 시작"

# === [0] 설정 ===
SERVICE_NAME="backend-service"
JAR_PATH="build/libs/*.jar"

# === [1] 현재 작업 디렉토리 확인 ===
echo "📁 현재 작업 디렉토리: $(pwd)"

# === [2] 기존 PM2 프로세스 종료 ===
echo "🛑 기존 PM2 프로세스 종료: $SERVICE_NAME"
pm2 delete "$SERVICE_NAME" || true

# === [3] PM2로 Spring Boot 실행 ===
echo "🚦 PM2로 Spring Boot 실행: $SERVICE_NAME"
pm2 start java \
  --name "$SERVICE_NAME" \
  -- -jar $JAR_PATH

# === [4] PM2 상태 저장 및 확인 ===
pm2 save
pm2 status