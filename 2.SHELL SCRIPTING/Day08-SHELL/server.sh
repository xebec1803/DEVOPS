#!/bin/bash

servers=("Web-Server" "Database-Server" "Application-Server" "Backup-Server")

count=0

for server in "${servers[@]}"
do
    echo "Checking $server..."
    count=$((count + 1))
done

echo "Total Servers Checked: $count"
