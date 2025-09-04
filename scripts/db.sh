#!/usr/bin/env bash

echo "Starting local database(s)..."
docker compose -f ./docker/docker-compose.yml down -t 0 -v
docker compose -f ./docker/docker-compose.yml up -d
echo -n "Waiting for database(s) "
until [ "$(docker ps | grep -vc "healthy" || echo 0)" -eq 1 ]; do sleep 1; echo -n "."; done
echo -n " Database(s) ready!"
echo
./scripts/orchestrate_plan.py
