
#!/bin/bash

check_net() {
    if ping -c 1 google.com >/dev/null 2>&1; 
    then
        echo "Internet is Connected"
    else
        echo "Internet is Not Connected"
    fi
}

check_net
