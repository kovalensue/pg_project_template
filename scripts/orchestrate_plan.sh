#!/usr/bin/env bash

# Orchestrator: reads orchestration.plan and applies migrations to correct targets

orchestration_plan="migrations/orchestration.plan"
if [ ! -f "$orchestration_plan" ]; then
    echo "Orchestration plan '$orchestration_plan' not found."
    exit 1
fi

exec 3< "$orchestration_plan"
while IFS= read -r line <&3; do

    # Skip empty and comment lines
    if [[ -z "$line" || "$line" =~ ^# ]]; then
        continue
    fi

    echo $line

    # Parse <target>:<migration>
    if [[ $line =~ ^([a-zA-Z0-9_@]+):([a-zA-Z0-9_]+)$ ]]; then
        target="${BASH_REMATCH[1]}"
        migration="${BASH_REMATCH[2]}"
        echo "Applying migration '$migration' to target '$target'..."
        ./sqitch deploy --change "$migration" --target "$target"
        if [ $? -ne 0 ]; then
            echo "Error applying migration '$migration' to '$target'."
            exit 1
        fi
        echo "Migration '$migration' applied to '$target'."
    else
        echo "Skipping line (invalid format): $line"
    fi

done
exec 3<&-
