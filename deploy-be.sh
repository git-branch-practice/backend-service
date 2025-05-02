#!/bin/bash
set -euo pipefail

echo "🚀 [START] 백엔드 서비스(Spring Boot) 배포 시작"

# === [0] 설정 ===
SERVICE_NAME="backend-service"

# === [1] 작업 디렉토리로 이동 ===
echo "📁 작업 디렉토리 이동: $HOME"
cd "$HOME"

# === [2] 기존 PM2 프로세스 종료 ===
echo "🛑 기존 PM2 프로세스 종료: $SERVICE_NAME"
pm2 delete "$SERVICE_NAME" || true

# === [3] Gradle 빌드 ===
echo "🏗️ Gradle 빌드 시작..."
cd "$HOME/backend-service"  # 프로젝트 루트
./gradlew build

# === [4] JAR 파일 확인 ===
JAR_FILE=$(find build/libs -name "*.jar" | head -n 1)

if [[ -z "$JAR_FILE" ]]; then
  echo "❌ JAR 파일이 없습니다. 빌드를 확인하세요."
  exit 1
fi

echo "📦 실행할 JAR 파일: $JAR_FILE"

# === [5] PM2로 Spring Boot 실행 ===
echo "🚦 PM2로 Spring Boot 실행: $SERVICE_NAME"
pm2 start java \
  --name "$SERVICE_NAME" \
  -- -jar "$JAR_FILE"

# === [6] PM2 상태 저장 및 확인 ===
pm2 save
pm2 status

echo "✅ [DONE] 백엔드 서비스 배포 완료"
