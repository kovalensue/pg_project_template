#!/usr/bin/env bash

mapfile -t targets < <(./sqitch target | grep -E '^local@' | sed 's/^local@//');
for i in "${!targets[@]}"; do
    echo "Dumping database for target '${targets[i]}'...";
    docker exec -it "${targets[i]}" pg_dumpall --schema-only --no-role-passwords -U postgres > "dumps/${targets[i]//[:@]/_}.sql";
    echo "Dumped database for target '${targets[i]}' to 'dumps/${targets[i]//[:@]/_}.sql'.";
done;