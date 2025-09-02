#!/usr/bin/env bash

# Orchestrator: parse root plan and apply migrations to target from prefix

# Get root plan file from sqitch.conf [core] section
root_plan_file=$(awk -F'=' '/^\[core\]/{f=1;next}/^\[/{f=0}f && $1~"plan_file"{gsub(/ /, "", $2); print $2}' sqitch.conf)
if [ -z "$root_plan_file" ] || [ ! -f "$root_plan_file" ]; then
    echo "Root plan file '$root_plan_file' not found or empty."
    exit 1
fi

while IFS= read -r line; do
    # Skip empty lines
    if [[ -z "$line" ]]; then
        continue
    fi
    # Skip meta lines
    if [[ "$line" =~ ^% ]]; then
        continue
    fi
    # Extract target and change name
    if [[ $line =~ ^([a-zA-Z0-9_]+)\;([a-zA-Z0-9_]+)[[:space:]] ]]; then
        target="${BASH_REMATCH[1]}"
        change_name="${BASH_REMATCH[2]}"
        sqitch_target="local@${target}"
        # Check if target exists in sqitch.conf
        if ! grep -q "\[target \"$sqitch_target\"\]" sqitch.conf; then
            echo "Target '$sqitch_target' not found in sqitch.conf. Skipping migration '$change_name'."
            continue
        fi
        echo "Applying migration '$change_name' to target '$sqitch_target'..."
        ./sqitch deploy --change "${change_name}" -t "$sqitch_target"
        if [ $? -ne 0 ]; then
            echo "Error applying migration '$change_name' to '$sqitch_target'."
            exit 1
        fi
        echo "Migration '$change_name' applied to '$sqitch_target'."
    else
        echo "Skipping line (no valid migration format): $line"
    fi

done < "$root_plan_file"
