
#!/bin/bash

number=$1


if [ "$number" -gt 0 ]
then
    echo "Positive Number"
else
    echo "Negative Number"
fi


if [ $((number % 2)) -eq 0 ]
then
    echo "Even Number"
else
    echo "Odd Number"
fi


if [ "$number" -gt 100 ]
then
    echo "Greater than 100"
else
    echo "Not greater than 100"
fi
