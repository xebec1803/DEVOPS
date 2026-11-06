
#!/bin/bash

while true
do
    read -r -p "Enter the backup folder/path: " backup

    if [ -d "$backup" ]
    then
        echo "Directory exists..."
        break
    else
        echo "Directory doesn't exist..."

        read -r -p "Do you want to create a new directory? [Y/N]: " choice

        if [ "$choice" = "Y" ]
        then
            mkdir -p "$backup"

            if [ -d "$backup" ]
            then
                echo "Directory created successfully..."
                break
            else
                echo "Directory wasn't created... please try again."
            fi
        else
            echo "Please choose another directory."
        fi
    fi
done

while true
do
    read -r -p "Enter source folder path: " source

    if [ -d "$source" ]
    then
        echo "Source directory exists..."
        break
    else
        echo "Source directory doesn't exist..."
        echo "Please enter a valid source folder..."
    fi
done

while true
do
    read -r -p "Enter log folder path: " log

    if [ -d "$log" ]
    then
        echo "Log directory exists..."
        break
    else
        echo "Directory doesn't exist..."
        read -r -p "Do you want to create it? [Y/N]: " choice

        if [ "$choice" = "Y" ]
        then
            mkdir -p "$log"

            if [ -d "$log" ]
            then
                echo "Log directory created successfully..."
                break
            else
                echo "Directory creation failed..."
            fi
        else
            echo "Please choose another directory..."
        fi
    fi
done

cp -r $source $backup

today=$(date +%Y%m%d_%H%M%S)
if tar -czf "$backup/backup_$today.tar.gz" -C "$source" .
then
    echo "Backup created successfully..."

    echo "Backup successful on $today" >> "$log/backup.log"
else
    echo "Backup failed..."

    echo "Backup failed on $today" >> "$log/backup.log"
fi



