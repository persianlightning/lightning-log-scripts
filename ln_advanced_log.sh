#!/bin/bash

# Default parameters
log_file="$HOME/.lightning/lightningd.log"
channel_id=""
tail_options="-f"

# Process command-line parameters
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--log) log_file="$2"; shift ;;
    -c|--channel) channel_id="$2"; shift ;;
    -t|--tail) tail_options="$2"; shift ;;
    *) echo "Invalid parameter: $1"; exit 1 ;;
  esac
  shift
done

# Check if the log file exists
if [[ ! -f "$log_file" ]]; then
  echo "Log file not found: $log_file"
  exit 1
fi

# Execute the tail command with specified options
tail $tail_options "$log_file" | while read line; do
  # Filter logs based on channel ID (if specified)
  if [[ -n "$channel_id" ]]; then
    if [[ "$line" != *"$channel_id"* ]]; then
      continue
    fi
  fi

  # Extract UTC time and convert it to local time
  timestamp=$(echo "$line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}Z')
  if [[ -n "$timestamp" ]]; then
    local_time=$(date -d "$timestamp" +"%Y-%m-%d %H:%M:%S")
    echo "${line/$timestamp/$local_time}"
  else
    echo "$line"
  fi
done
