
#!/bin/bash


students=("Akash" "Rahul" "Neeraj" "Arjun" "Vishnu")


echo "Student List:"
for student in "${students[@]}"
do
    echo "$student"
done


echo "Total Students: ${#students[@]}"


read -p "Enter student name to search: " search

found=0

for student in "${students[@]}"
do
    if [ "$student" = "$search" ]
    then
        found=1
        break
    fi
done

if [ "$found" -eq 1 ]
then
    echo "Student Found"
else
    echo "Student Not Found"
fi

