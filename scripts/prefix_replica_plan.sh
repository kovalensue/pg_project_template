#!/bin/bash
# Script to prefix every migration in sqitch.plan with 'replica;'

PLAN_FILE="/home/koval/git/pg_project_template/migrations/my_app_replica/sqitch.plan"
TMP_FILE="${PLAN_FILE}.tmp"

awk '{
    if ($0 ~ /^[^%].*$/ && NF > 0) {
        print "replica;" $0
    } else {
        print $0
    }
}' "$PLAN_FILE" > "$TMP_FILE"

mv "$TMP_FILE" "$PLAN_FILE"
echo "All migrations in sqitch.plan have been prefixed with 'replica;'"
