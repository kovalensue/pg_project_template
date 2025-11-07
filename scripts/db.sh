#!/usr/bin/env bash

echo "Starting local database(s)..."
docker compose -f ./docker/docker-compose.yml down -t 0 -v
docker compose -f ./docker/docker-compose.yml up -d
echo -n "Waiting for database(s) "
while docker compose -f ./docker/docker-compose.yml ps --format "{{.Status}}" | grep -vq "healthy"; do
  sleep 1
  echo -n "."
done
echo -n " Database(s) ready!"
echo
./scripts/orchestrate_plan.py
