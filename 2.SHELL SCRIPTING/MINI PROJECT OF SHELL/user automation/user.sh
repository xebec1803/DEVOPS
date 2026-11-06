
#!/bin/bash

mkdir -p log
logfile="log/user.log"

write_log()
{
    echo "Username: $1 | Status: $2 | Date: $(date '+%Y-%m-%d') | Time: $(date '+%H:%M:%S')" >> "$logfile"
}

read -r -p "How many users do you want to create? " count

while [ "$count" -le 0 ]
do
    echo "Please enter a valid number..."
    read -r -p "How many users do you want to create? " count
done

for ((i=1; i<=count; i++))
do
    read -r -p "Enter username $i: " username

    if id "$username" &>/dev/null
    then
        echo "User $username already exists. Skipping..."
        write_log "$username" "Already exists - skipped"
    else
        if sudo useradd "$username"
        then
            echo "User $username created successfully..."
            write_log "$username" "Created successfully"
        else
            echo "Failed to create user $username..."
            write_log "$username" "Creation failed"
        fi
    fi
done

echo "User creation process completed."

