#!/bin/bash

source ./scan_log.sh
source ./system_scan.sh

function show_menu() 
{
    echo "Select an option:"
    echo "1) Enter path of log file"
    echo "2) Run system scan"
    echo "3) Exit"
}

function show_scan_options() 
{
    echo "Select scan duration:"
    echo "1) Entire duration"
    echo "2) One week"
    echo "3) Today"
}

function enter_log_path() 
{
    read -p "Enter the path of the log file: " log_path

    if [[ -f "$log_path" ]]; then
        scan_log_file "$log_path"
    else
        echo "Invalid file path. Please try again."
    fi
}

function run_system_scan() 
{
    while true; do
        show_scan_options
        read -p "Enter your choice: " scan_choice

        case $scan_choice in
            1)
                clear
                echo "Running system scan for entire duration..."
                scan_entire_system
                break
                ;;
            2)
                clear
                echo "Running system scan for the past week..."
                scan_past_week
                break
                ;;
            3)
                clear
                echo "Running system scan for today..."
                scan_today
                break
                ;;
            *)
                echo "Invalid choice, please try again."
                ;;
        esac
    done
}


while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            enter_log_path
            ;;
        2)
            run_system_scan
            ;;
        3)
            echo "Exiting the program."
            exit 0
            ;;
        *)
            echo "Invalid choice, please try again."
            ;;
    esac
done
