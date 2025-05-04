#!/bin/bash
set -euo pipefail
# -e: 에러 발생 시 스크립트 즉시 종료
# -u: 정의되지 않은 변수 사용 시 에러
# -o pipefail: 파이프라인 중 하나라도 실패 시 전체 실패 처리

echo "🚀 [START] 백엔드 서비스(Spring Boot) 배포 시작"

# ✅ NVM 환경 수동 로드
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

APP_NAME="nemo-backend"
JAR="latest.jar"

# ✅ pm2 설치 확인 및 설치
if ! command -v pm2 &> /dev/null; then
  echo "🔧 pm2가 설치되어 있지 않음. 설치 중..."
  npm install -g pm2
else
  echo "✅ pm2 설치되어 있음"
fi

# 1. 기존 PM2 프로세스 종료
echo "🛑 기존 PM2 프로세스 종료: $APP_NAME"
pm2 delete "$APP_NAME" || echo "ℹ️ 기존 PM2 프로세스 없음"

# 2. 최신 JAR 실행 (.env에서 환경변수 로딩)
echo "🚀 최신 JAR 실행 중: $JAR"
pm2 start "java -jar $JAR" --name "$APP_NAME" --env .env


