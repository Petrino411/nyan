#!/bin/bash
set -e

# Переходим в директорию с compose-файлом
cd "$(dirname "$0")"


MONGO_DATA="/mnt/data/mongocontainer"

echo "[mongo-recreate] Stopping mongo container..."
docker-compose stop mongo

echo "[mongo-recreate] Removing MongoDB data..."
rm -rf ${MONGO_DATA:?}/*

echo "[mongo-recreate] Starting mongo container..."
docker-compose up -d mongo

echo "[mongo-recreate] Done."
