#!/bin/bash

# main.sh - This script presents a menu for the user to interact with system tasks

# Include the scan_log.sh and system_scan.sh scripts
source ./scan_log.sh
source ./system_scan.sh
export LANG=en_US.UTF-8
# Color definitions
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'
DIM='\033[2m'

# Function to display the main header
function show_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${BOLD}${CYAN}            SYSTEM MENU                 ${NC}${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"
}

# Function to display the main menu
function show_menu() {
    show_header
    echo -e "${CYAN}  ╔════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${YELLOW} Select an option:              ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠════════════════════════════════╣${NC}"
    echo -e "${CYAN}  ║${GREEN} 1)${NC} Enter path of log file      ${CYAN}║${NC}"
    echo -e "${CYAN}  ║${GREEN} 2)${NC} Run system scan             ${CYAN}║${NC}"
    echo -e "${CYAN}  ║${GREEN} 3)${NC} Exit                        ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚════════════════════════════════╝${NC}"
}

# Function to display system scan options
function show_scan_options() {
    echo -e "\n${PURPLE}╔════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${BOLD}        SYSTEM SCAN OPTIONS             ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}  ╔════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${YELLOW} Select scan duration:          ${CYAN}║${NC}"
    echo -e "${CYAN}  ╠════════════════════════════════╣${NC}"
    echo -e "${CYAN}  ║${GREEN} 1)${NC} Entire duration             ${CYAN}║${NC}"
    echo -e "${CYAN}  ║${GREEN} 2)${NC} One week                    ${CYAN}║${NC}"
    echo -e "${CYAN}  ║${GREEN} 3)${NC} Today                       ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚════════════════════════════════╝${NC}"
}

# Function to read log file path from the user and choose scan type
function enter_log_path() {
    echo -e "\n${PURPLE}╔════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${BOLD}           LOG FILE SELECTION           ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════╝${NC}"
    read -p "$(echo -e ${GREEN}"Enter the path of the log file: "${NC})" log_path

    if [[ -f "$log_path" ]]; then
        echo -e "\n${DIM}Processing log file at: ${BOLD}$log_path${NC}\n"
        
        echo -e "${CYAN}  ╔═════════════════════════════════╗${NC}"
        echo -e "${CYAN}  ║${YELLOW} Select scan type:               ${CYAN}║${NC}"
        echo -e "${CYAN}  ╠═════════════════════════════════╣${NC}"
        echo -e "${CYAN}  ║${GREEN} 1)${NC} Run general scan             ${CYAN}║${NC}"
        echo -e "${CYAN}  ║${GREEN} 2)${NC} Search for a particular error${CYAN}║${NC}"
        echo -e "${CYAN}  ╚═════════════════════════════════╝${NC}"
        read -p "$(echo -e ${GREEN}"Enter your choice: "${NC})" scan_type

      # In scan_log.sh, modify the case statement:
         case $scan_type in
    1)
        echo -e "\n${YELLOW}Running general scan on $log_path...${NC}"
        analyze_log "$log_path"
        ;;
    2)
        read -p "$(echo -e ${GREEN}"Enter the error message to search for: "${NC})" error_message
        echo -e "\n${YELLOW}Searching for occurrences of '$error_message' in $log_path...${NC}\n"
        analyze_patterns "$log_path" "$error_message" "Error Pattern"  # Fixed line
        ;;
    *)
        echo -e "${RED}Invalid choice, please try again.${NC}"
        ;;
esac
    else
        echo -e "${RED}Invalid file path. Please try again.${NC}"
    fi
}

# Function to run system scan based on user's choice
function run_system_scan() {
    while true; do
        show_scan_options
        read -p "$(echo -e ${GREEN}"Enter your choice: "${NC})" scan_choice

        case $scan_choice in
            1)
                clear
                echo -e "\n${BLUE}╔════════════════════════════════════════╗${NC}"
                echo -e "${BLUE}║${YELLOW}    Running system scan for entire      ${BLUE}║${NC}"
                echo -e "${BLUE}║${YELLOW}            duration...                 ${BLUE}║${NC}"
                echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
                scan_entire_system
                break
                ;;
            2)
                clear
                echo -e "\n${BLUE}╔════════════════════════════════════════╗${NC}"
                echo -e "${BLUE}║${YELLOW}      Running system scan for           ${BLUE}║${NC}"
                echo -e "${BLUE}║${YELLOW}           the past week...             ${BLUE}║${NC}"
                echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
                scan_past_week
                break
                ;;
            3)
                clear
                echo -e "\n${BLUE}╔════════════════════════════════════════╗${NC}"
                echo -e "${BLUE}║${YELLOW}       Running system scan for          ${BLUE}║${NC}"
                echo -e "${BLUE}║${YELLOW}             today...                   ${BLUE}║${NC}"
                echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
                scan_today
                break
                ;;
            *)
                echo -e "${RED}Invalid choice, please try again.${NC}"
                ;;
        esac
    done
}

# Main loop to process user choices
while true; do
    show_menu
    read -p "$(echo -e ${GREEN}"Enter your choice: "${NC})" choice

    case $choice in
        1)
            enter_log_path
            ;;
        2)
            run_system_scan
            ;;
        3)
            echo -e "\n${PURPLE}╔════════════════════════════════════════╗${NC}"
            echo -e "${PURPLE}║${YELLOW}        Exiting the program.            ${PURPLE}║${NC}"
            echo -e "${PURPLE}╚════════════════════════════════════════╝${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice, please try again.${NC}"
            ;;
    esac
done