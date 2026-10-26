
#!/bin/bash

user_info() 
{
echo "Username: $(whoami)"
echo "Shell Name: $SHELL"
echo "Hostname: $(hostname)"
}

user_info
