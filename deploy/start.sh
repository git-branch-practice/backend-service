#!/bin/bash
echo "[CD] Starting Spring Boot..."
JAR=$(ls -t ~/deploy/backend/*.jar | head -n 1)
[ -z "$JAR" ] && echo "[CD] ❌ No jar file" && exit 1
nohup java -jar "$JAR" > ~/deploy/spring.log 2>&1 &
sleep 3
tail -n 10 ~/deploy/spring.log
