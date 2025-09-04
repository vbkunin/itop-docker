#!/usr/bin/env bash
# LOG_STDOUT = "file1:tag1,file2,file3:tag3"
# LOG_STDERR = "file4:tag4,file5"

declare -A monitored

monitor_file() {
    local logfile="$1"
    local tag="$2"
    local output="$3"  # stdout or stderr

    [ -z "$tag" ] && tag="$logfile"

    if [ -n "${monitored[$logfile]}" ]; then
        return
    fi
    monitored[$logfile]=1

    (
        while [ ! -f "$logfile" ]; do
            sleep 1
        done

        tail -F "$logfile" 2>/dev/null | while read -r line; do
            if [ "$output" = "stderr" ]; then
                echo "[$tag] $line" >&2
            else
                echo "[$tag] $line"
            fi
        done
    ) &
}

process_log_var() {
    local var_value="$1"
    local output="$2"
    [ -z "$var_value" ] && return

    IFS=',' read -r -a entries <<< "$var_value"
    for entry in "${entries[@]}"; do
        IFS=':' read -r logfile tag <<< "$entry"
        monitor_file "$logfile" "$tag" "$output"
    done
}

process_log_var "$LOG_STDOUT" "stdout"
process_log_var "$LOG_STDERR" "stderr"

wait