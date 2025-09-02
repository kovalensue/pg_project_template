#!/usr/bin/env bash

# Wrapper for sqitch add that also prefixes the last migration in the plan

read -p "Enter change name: " name
read -p "Enter change description: " desc

mapfile -t targets < <(./sqitch target | grep -E '^local@.*$')
for i in "${!targets[@]}"; do echo "$((i+1))) ${targets[i]}"; done
read -p "Select target(s) (comma-separated numbers): " selection

selected=($(echo "$selection" | tr ',' ' '))
for i in "${selected[@]}"; do
    target="${targets[i-1]}"
    ./sqitch add -m "${desc}" "${name}" "$target"
    # Use target value as prefix
    prefix="${target#local@}"

    # Get root plan file from sqitch.conf [core] section (INI parsing)
    root_plan_file=$(awk -F'=' '/^\[core\]/{f=1;next}/^\[/{f=0}f && $1~"plan_file"{gsub(/ /, "", $2); print $2}' sqitch.conf)

    # Prefix last migration in root plan file
    if [ -n "$root_plan_file" ] && [ -f "$root_plan_file" ]; then
        awk -v pfx="$prefix" '{lines[NR]=$0} END {for(i=1;i<=NR;i++){if(i==NR && $0 !~ /^%/ && NF>0){print pfx ";" lines[i]}else{print lines[i]}}}' "$root_plan_file" > "$root_plan_file.tmp" && mv "$root_plan_file.tmp" "$root_plan_file"
        echo "Prefixed last migration in $root_plan_file with '$prefix;'"
    else
        echo "Root plan file '$root_plan_file' not found or empty."
        exit 1
    fi
done
