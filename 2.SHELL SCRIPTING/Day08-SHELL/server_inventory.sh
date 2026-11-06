#!/bin/bash

servers=()

while true
do
    
    echo "   SERVER INVENTORY"
    echo "1. Add Server"
    echo "2. View Servers"
    echo "3. Search Server"
    echo "4. Count Servers"
    echo "5. Exit"

    read -p "Enter your choice: " choice

    if [ "$choice" -eq 1 ]
    then
        read -p "Enter server name: " name
        servers+=("$name")
        echo "Server Added Successfully"

    elif [ "$choice" -eq 2 ]
    then
        echo "Server List:"
        for server in "${servers[@]}"
        do
            echo "$server"
        done

    elif [ "$choice" -eq 3 ]
    then
        read -p "Enter server name to search: " search
        found=0

        for server in "${servers[@]}"
        do
            if [ "$server" = "$search" ]
            then
                found=1
                break
            fi
        done

        if [ "$found" -eq 1 ]
        then
            echo "Server Found"
        else
            echo "Server Not Found"
        fi

    elif [ "$choice" -eq 4 ]
    then
        echo "Total Servers: ${#servers[@]}"

    elif [ "$choice" -eq 5 ]
    then
        echo "Exiting Application..."
        break

    else
        echo "Invalid Choice"
    fi

    echo ""
done
