function scan_entire_system()
{
    echo "Starting system scan..."
    
    echo "Checking disk space usage:"

    df -h
    
    echo "Checking memory usage:"

    free -h
    
    echo "Checking CPU load:"

    uptime
    
    echo "System scan completed."
}

function scan_syslog() 
{
    file_path="/var/log/syslog"

    if [[ -f "$file_path" ]]; then
        echo "---------------------------------------------"
        echo "        System Log Error Scan Report         "
        echo "---------------------------------------------"

        memory_error_count=$(grep -Eoi "OOM killer enabled|Out of memory" "$file_path" | wc -l)
        throttling_error_count=$(grep -Eoi "cpu clock is throttled" "$file_path" | wc -l)
        disk_io_error_count=$(grep -Eoi "Invalid buffer destination" "$file_path" | wc -l)
        bios_error_count=$(grep -Eoi "ACPI BIOS" "$file_path" | wc -l)
        network_error_count=$(grep -Eoi "Network unreachable|link is down" "$file_path" | wc -l)
        filesystem_error_count=$(grep -Eoi "EXT4-fs error" "$file_path" | wc -l)
        highload_error_count=$(grep -Eoi "blocked for more than" "$file_path" | wc -l)

        printf "%-40s: %d\n" "Memory error occurrences" "$memory_error_count"
        printf "%-40s: %d\n" "Throttling related error occurrences" "$throttling_error_count"
        printf "%-40s: %d\n" "I/O and buffer related error occurrences" "$disk_io_error_count"
        printf "%-40s: %d\n" "BIOS related error occurrences" "$bios_error_count"
        printf "%-40s: %d\n" "Network related error occurrences" "$network_error_count"
        printf "%-40s: %d\n" "Filesystem related error occurrences" "$filesystem_error_count"
        printf "%-40s: %d\n" "High Load related error occurrences" "$highload_error_count"

        echo "---------------------------------------------"
    else
        echo "Error: syslog file not found at $file_path."
    fi
}

function scan_syslog_last_7_days() 
{
    file_path="/var/log/syslog"

    today=$(date "+%Y-%m-%dT%H:%M:%S")
    seven_days_ago=$(date --date="7 days ago" "+%Y-%m-%dT%H:%M:%S")

    if [[ -f "$file_path" ]]; then
        echo "---------------------------------------------"
        echo "     System Log Error Scan (Last 7 Days)     "
        echo "---------------------------------------------"

        temp_log_file=$(mktemp)
        awk -v start="$seven_days_ago" -v end="$today" '$0 >= start && $0 <= end' "$file_path" > "$temp_log_file"

        total_memory_error_count=0
        total_throttling_error_count=0
        total_disk_io_error_count=0
        total_bios_error_count=0
        total_network_error_count=0
        total_filesystem_error_count=0
        total_highload_error_count=0

        declare -A daily_error_counts

        for (( i=0; i<7; i++ )); do
            date=$(date --date="$i days ago" "+%Y-%m-%d")

            daily_log=$(grep "$date" "$temp_log_file")

            memory_error_count=$(echo "$daily_log" | grep -Eoi "OOM killer enabled|Out of memory" | wc -l)
            throttling_error_count=$(echo "$daily_log" | grep -Eoi "cpu clock is throttled" | wc -l)
            disk_io_error_count=$(echo "$daily_log" | grep -Eoi "Invalid buffer destination" | wc -l)
            bios_error_count=$(echo "$daily_log" | grep -Eoi "ACPI BIOS" | wc -l)
            network_error_count=$(echo "$daily_log" | grep -Eoi "Network unreachable|link is down" | wc -l)
            filesystem_error_count=$(echo "$daily_log" | grep -Eoi "EXT4-fs error" | wc -l)
            highload_error_count=$(echo "$daily_log" | grep -Eoi "blocked for more than" | wc -l)

            total_memory_error_count=$((total_memory_error_count + memory_error_count))
            total_throttling_error_count=$((total_throttling_error_count + throttling_error_count))
            total_disk_io_error_count=$((total_disk_io_error_count + disk_io_error_count))
            total_bios_error_count=$((total_bios_error_count + bios_error_count))
            total_network_error_count=$((total_network_error_count + network_error_count))
            total_filesystem_error_count=$((total_filesystem_error_count + filesystem_error_count))
            total_highload_error_count=$((total_highload_error_count + highload_error_count))

            total_errors_for_day=$(( memory_error_count + throttling_error_count + disk_io_error_count + bios_error_count + network_error_count + filesystem_error_count + highload_error_count ))

            daily_error_counts["$date"]=$total_errors_for_day
        done

        echo "Weekly Total Error Summary:"
        printf "%-40s: %d\n" "Memory error occurrences" "$total_memory_error_count"
        printf "%-40s: %d\n" "Throttling related error occurrences" "$total_throttling_error_count"
        printf "%-40s: %d\n" "I/O and buffer related error occurrences" "$total_disk_io_error_count"
        printf "%-40s: %d\n" "BIOS related error occurrences" "$total_bios_error_count"
        printf "%-40s: %d\n" "Network related error occurrences" "$total_network_error_count"
        printf "%-40s: %d\n" "Filesystem related error occurrences" "$total_filesystem_error_count"
        printf "%-40s: %d\n" "High Load related error occurrences" "$total_highload_error_count"
        echo "---------------------------------------------"

        echo "Daily Error Summary (Last 7 Days):"
        for (( i=0; i<7; i++ )); do
            date=$(date --date="$i days ago" "+%Y-%m-%d")
            total_errors=${daily_error_counts[$date]}

            if [[ $total_errors -lt 10 ]]; then
                color="\e[32m"  # Green
            elif [[ $total_errors -le 20 ]]; then
                color="\e[33m"  # Yellow
            else
                color="\e[31m"  # Red
            fi

            if [[ $total_errors -eq 0 ]]; then
                bar_graph="▇"  # Single block for 0 errors
            else
                bar_graph=$(printf "%0.s▇" $(seq 1 $total_errors))
            fi

            printf "Date: %-15s Total Errors: ${color}%s\e[0m %d\n" "$date" "$bar_graph" "$total_errors"
        done

        echo "---------------------------------------------"

        rm "$temp_log_file"
    else
        echo "Error: syslog file not found at $file_path."
    fi
}

function scan_past_week()
{
    scan_syslog_last_7_days
}

function scan_entire_system()
{
    scan_syslog
}