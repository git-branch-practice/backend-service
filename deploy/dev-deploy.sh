#!/bin/bash
set -euo pipefail
# -e: 에러 시 종료, -u: 정의되지 않은 변수 오류, -o pipefail: 파이프 실패 감지

echo "🚀 [START] 백엔드 서비스(Spring Boot) 배포 시작"

APP_NAME="nemo-backend"
JAR="latest.jar"

# 0. NVM 환경 로드 및 PM2 설치
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
npm install -g pm2

# 1. 기존 프로세스 종료
echo "🛑 기존 PM2 프로세스 종료: $APP_NAME"
pm2 delete "$APP_NAME" || echo "ℹ️ 기존 프로세스 없음"

# 2. 최신 JAR 실행
if [ ! -f "$JAR" ]; then
  echo "❌ JAR 파일이 존재하지 않습니다: $JAR"
  exit 1
fi

if [ ! -f ".env" ]; then
  echo "⚠️ .env 파일이 없습니다. 환경변수 없이 실행됩니다."
fi

echo "🚀 최신 JAR 실행 중: $JAR"
pm2 start "java -jar $JAR" --name "$APP_NAME" --env .env

# PM2 상태 저장
pm2 save

# 3. 헬스체크
#echo "🩺 헬스체크 시작..."
#
#if [ ! -x ./validate.sh ]; then
#  echo "⚠️ validate.sh 파일이 없거나 실행 권한이 없습니다. 헬스체크 생략"
#  exit 0
#fi
#
#for i in {1..5}; do
#  if ./validate.sh; then
#    echo "✅ 배포 및 헬스체크 성공"
#    exit 0
#  fi
#  echo "⏳ 헬스체크 재시도 ($i/5)..."
#  sleep 3
#done
#
#echo "❌ 헬스체크 실패"
#exit 1
