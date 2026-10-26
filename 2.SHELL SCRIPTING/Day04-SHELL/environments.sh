
#!/bin/bash

for env in Dev Test Stage Prod
do
    mkdir -p "$env"
    echo "$env folder created"
done
