#!/bin/bash

function scan_log_file() 
{
    local log_path="$1"

    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    CYAN='\033[0;36m'
    BLUE='\033[0;34m'
    RESET='\033[0m'


    echo -e "${CYAN}-----------------------------------"
    echo "        Scanning log file: $log_path"
    echo -e "-----------------------------------${RESET}"

    if [[ -f "$log_path" ]]; then

        error_count=$(grep -Eoi "error" "$log_path" | wc -l)
        warning_count=$(grep -Eoi "warning" "$log_path" | wc -l)
        authentication_failure_count=$(grep -Eoi "authentication failure" "$log_path" | wc -l)

        echo -e "${RED}Number of 'error' occurrences: $error_count${RESET}"
        echo -e "${YELLOW}Number of 'warning' occurrences: $warning_count${RESET}"
        echo -e "${BLUE}Number of 'authentication failure' occurrences: $authentication_failure_count${RESET}"

        echo -e "${CYAN}-----------------------------------${RESET}"

        if [[ "$error_count" -gt 0 ]]; then
            echo -e "${RED}Error messages:${RESET}"
            grep -Eio ".*error.*" "$log_path" | cut -d' ' -f6- | sort | uniq | sed 's/^/   - /'
        else
            echo -e "${GREEN}No error messages found.${RESET}"
        fi

        if [[ "$warning_count" -gt 0 ]]; then
            echo -e "${YELLOW}Warning messages:${RESET}"
            grep -Eio ".*warning.*" "$log_path" | cut -d' ' -f6- | sort | uniq | sed 's/^/   - /'
        else
            echo -e "${GREEN}No warning messages found.${RESET}"
        fi

        if [[ "$authentication_failure_count" -gt 0 ]]; then
            echo -e "${BLUE}Authentication failure messages:${RESET}"
            grep -Eio ".*authentication failure.*" "$log_path" | cut -d' ' -f6- | sort | uniq | sed 's/^/   - /'
        else
            echo -e "${GREEN}No authentication failure messages found.${RESET}"
        fi

        echo -e "${CYAN}-----------------------------------${RESET}"

    else
        echo -e "${RED}Error: The file does not exist or the path is incorrect.${RESET}"
    fi
}

