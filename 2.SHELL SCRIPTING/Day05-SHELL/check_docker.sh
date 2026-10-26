
#!/bin/bash

check_docker() 
{
    if command -v docker >/dev/null 2>&1; 
    then
        echo "Docker is Installed"
    else
        echo "Docker is Not Installed"
    fi
}

check_docker
