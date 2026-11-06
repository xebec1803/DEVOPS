#!/bin/bash

touch courses.txt

echo "Linux" > courses.txt
echo "Docker" >> courses.txt
echo "Kubernetes" >> courses.txt
echo "AWS" >> courses.txt

echo "Course List:"
cat courses.txt

echo "Total Courses:"
wc -l < courses.txt

if [ -f courses.txt ]
then
    echo "File Exists"
else
    echo "File Not Found"
fi
