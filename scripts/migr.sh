#!/usr/bin/env bash

# shellcheck disable=SC2162
# shellcheck disable=SC2207

read -p "Enter change name: " name;
read -p "Enter change description: " desc;

mapfile -t targets < <(./sqitch target | grep -E '^local@.*$');
for i in "${!targets[@]}"; do echo "$((i+1))) ${targets[i]}"; done;
read -p "Select target(s) (comma-separated numbers): " selection;

selected=($(echo "$selection" | tr ',' ' '));
for i in "${selected[@]}"; do
	target="${targets[i-1]}"
	./sqitch add -m "${desc}" "${name}" "$target"
	echo "$target:$name" >> migrations/orchestration.plan
	echo "Added migration '$target:$name' in orchestration.plan"
done
