
#!/bin/bash

workspace=""

# TASK 1 - LAB INITIALIZATION

lab_initialization()
{
    echo "===== LAB INITIALIZATION ====="

    read -p "Enter lab name: " lab_name

    if [ -z "$lab_name" ]; then
        echo "Lab name cannot be empty"
        return 1
    fi

    if [[ ! "$lab_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Invalid lab name"
        return 1
    fi

    mkdir -p projects

    workspace="projects/$lab_name"

    if [ -d "$workspace" ]; then
        echo "Lab already exists. Reusing workspace."
    else
        if ! mkdir -p "$workspace"; then
            echo "Failed to create workspace"
            return 1
        fi
    fi

    for folder in apps reports logs
    do
        if ! mkdir -p "$workspace/$folder"; then
            echo "Failed to create $folder"
            return 1
        fi
    done

    if [ ! -f "$workspace/lab_info.txt" ]; then
        echo "Lab Name: $lab_name" > "$workspace/lab_info.txt"
        echo "Creation Date: $(date)" >> "$workspace/lab_info.txt"
    fi

    if ! touch "$workspace/apps.txt"; then
        echo "Failed to create apps.txt"
        return 1
    fi

    echo "Lab initialized successfully!"
}


# TASK 2 - APPLICATION REGISTRATION

app_reg()
{
    app_file="$workspace/apps.txt"

    echo "===== APPLICATION REGISTRATION ====="

    read -p "Enter application name: " app_name

    if [ -z "$app_name" ]; then
        echo "Application name cannot be empty"
        return 1
    fi

    if [[ ! "$app_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Invalid application name"
        return 1
    fi

    while IFS='|' read -r old_name old_dev old_env old_status
    do
        if [ "$old_name" = "$app_name" ]; then
            echo "Application already exists"
            return 1
        fi
    done < "$app_file"

    read -p "Enter developer name: " dev_name

    if [ -z "$dev_name" ] || [[ "$dev_name" == *"|"* ]]; then
        echo "Invalid developer name"
        return 1
    fi

    read -p "Enter environment (dev/test/prod): " env_name

    case "$env_name" in
        dev|test|prod)
            echo "Valid environment"
            ;;
        *)
            echo "Invalid environment"
            return 1
            ;;
    esac

    status="PENDING"

    if echo "$app_name|$dev_name|$env_name|$status" >> "$app_file"; then
        echo "Application registered successfully"
        log_activity "REGISTER" "$app_name" "SUCCESS"
    else
        echo "Registration failed"
        return 1
    fi
}


# TASK 2 - LIST APPLICATIONS

list_apps()
{
    app_file="$workspace/apps.txt"

    if [ ! -s "$app_file" ]; then
        echo "No applications registered"
        return 0
    fi

    echo "===== REGISTERED APPLICATIONS ====="

    while IFS='|' read -r app_name dev_name env_name status
    do
        echo "Application: $app_name"
        echo "Developer: $dev_name"
        echo "Environment: $env_name"
        echo "Status: $status"
        echo "-------------------------"
    done < "$app_file"
}


# TASK 2 - SEARCH APPLICATION

search_app()
{
    app_file="$workspace/apps.txt"

    read -p "Enter application name to search: " search_name

    if [ -z "$search_name" ]; then
        echo "Search name cannot be empty"
        return 1
    fi

    found=0

    while IFS='|' read -r app_name dev_name env_name status
    do
        if [ "$app_name" = "$search_name" ]; then
            echo "Application Found!"
            echo "Name: $app_name"
            echo "Developer: $dev_name"
            echo "Environment: $env_name"
            echo "Status: $status"

            found=1
            break
        fi
    done < "$app_file"

    if [ "$found" -eq 0 ]; then
        echo "Application not found"
    fi
}


# TASK 3 - READINESS CHECKER

check_readiness()
{
    app_file="$workspace/apps.txt"

    read -p "Enter application name: " app_name

    found=0

    while IFS='|' read -r old_name dev_name env_name old_status
    do
        if [ "$old_name" = "$app_name" ]; then
            found=1
            break
        fi
    done < "$app_file"

    if [ "$found" -eq 0 ]; then
        echo "Application not registered"
        return 1
    fi

    app_dir="$workspace/apps/$app_name"

    folder_result="FAIL"
    start_result="FAIL"
    readme_result="FAIL"
    execute_result="FAIL"

    if [ -d "$app_dir" ]; then
        folder_result="PASS"
    fi

    if [ -f "$app_dir/start.sh" ]; then
        start_result="PASS"
    fi

    if [ -f "$app_dir/README.txt" ]; then
        readme_result="PASS"
    fi

    if [ -x "$app_dir/start.sh" ]; then
        execute_result="PASS"
    fi

    echo "Application folder: $folder_result"
    echo "start.sh: $start_result"
    echo "README.txt: $readme_result"
    echo "Execute permission: $execute_result"

    new_status="NOT_READY"

    if [ "$folder_result" = "PASS" ] &&
       [ "$start_result" = "PASS" ] &&
       [ "$readme_result" = "PASS" ] &&
       [ "$execute_result" = "PASS" ]; then

        new_status="READY"
    fi

    temp_file="$workspace/apps.txt.tmp"

    while IFS='|' read -r old_name old_dev old_env old_status
    do
        if [ "$old_name" = "$app_name" ]; then
            echo "$old_name|$old_dev|$old_env|$new_status" >> "$temp_file"
        else
            echo "$old_name|$old_dev|$old_env|$old_status" >> "$temp_file"
        fi
    done < "$app_file"

    if mv "$temp_file" "$app_file"; then
        echo "Final Status: $new_status"
        log_activity "CHECK" "$app_name" "$new_status"
    else
        echo "Failed to update application status"
        rm -f "$temp_file"
        return 1
    fi
}


# TASK 4 - ACTIVITY LOGGER

log_activity()
{
    action="$1"
    app_name="$2"
    result="$3"

    log_file="$workspace/logs/activity.log"

    if ! mkdir -p "$workspace/logs"; then
        echo "Cannot create logs folder"
        return 1
    fi

    if echo "$(date '+%Y-%m-%d %H:%M:%S') | $action | $app_name | $result" >> "$log_file"; then
        return 0
    else
        echo "Activity logging failed"
        return 1
    fi
}


# TASK 4 - DAILY REPORT

generate_report()
{
    app_file="$workspace/apps.txt"
    report_file="$workspace/reports/daily_report.txt"

    total=0
    ready=0
    not_ready=0
    pending=0

    lab_name="${workspace##*/}"

    mkdir -p "$workspace/reports"

    if [ -f "$app_file" ]; then

        while IFS='|' read -r app_name dev_name env_name status
        do
            if [ -n "$app_name" ]; then
                total=$((total + 1))

                case "$status" in
                    READY)
                        ready=$((ready + 1))
                        ;;
                    NOT_READY)
                        not_ready=$((not_ready + 1))
                        ;;
                    PENDING)
                        pending=$((pending + 1))
                        ;;
                esac
            fi
        done < "$app_file"
    fi

    if ! {
        echo "===== DAILY LAB REPORT ====="
        echo "Lab Name: $lab_name"
        echo "Date: $(date)"
        echo "Total Applications: $total"
        echo "READY: $ready"
        echo "NOT_READY: $not_ready"
        echo "PENDING: $pending"
    } > "$report_file"; then
        echo "Failed to create report"
        return 1
    fi

    echo "Report generated successfully"
    cat "$report_file"
}


# TASK 5 - HELP

show_help()
{
    echo "DEVOPS LAB MANAGER"
    echo "Usage:"
    echo "./lab_manager.sh"
    echo "./lab_manager.sh --help"
    echo "./lab_manager.sh --report LAB_NAME"
}


# TASK 5 - MAIN MENU

main_menu()
{
    while true
    do
        echo
        echo "===== DEVOPS LAB MANAGER ====="
        echo "1. Initialize Lab"
        echo "2. Register App"
        echo "3. List Apps"
        echo "4. Search App"
        echo "5. Check Readiness"
        echo "6. Generate Report"
        echo "7. Exit"

        read -p "Enter your choice: " choice

        case "$choice" in
            1)
                lab_initialization
                ;;
            2)
                if [ -z "$workspace" ]; then
                    echo "Initialize lab first"
                else
                    app_reg
                fi
                ;;
            3)
                if [ -z "$workspace" ]; then
                    echo "Initialize lab first"
                else
                    list_apps
                fi
                ;;
            4)
                if [ -z "$workspace" ]; then
                    echo "Initialize lab first"
                else
                    search_app
                fi
                ;;
            5)
                if [ -z "$workspace" ]; then
                    echo "Initialize lab first"
                else
                    check_readiness
                fi
                ;;
            6)
                if [ -z "$workspace" ]; then
                    echo "Initialize lab first"
                else
                    generate_report
                fi
                ;;
            7)
                echo "Exiting Lab Manager"
                break
                ;;
            *)
                echo "Invalid choice. Enter 1-7"
                ;;
        esac
    done
}


# COMMAND-LINE ARGUMENTS

case "$1" in
    --help)
        show_help
        ;;
    --report)
        if [ -z "$2" ] || [ "$#" -ne 2 ]; then
            echo "Usage: ./lab_manager.sh --report LAB_NAME"
            exit 1
        fi

        workspace="projects/$2"

        if [ ! -d "$workspace" ]; then
            echo "Lab does not exist"
            exit 1
        fi

        generate_report
        ;;
    "")
        main_menu
        ;;
    *)
        echo "Unknown argument"
        show_help
        exit 1
        ;;
esac

