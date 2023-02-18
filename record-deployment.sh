#!/bin/bash

# Record start time
start_time=$(date "+%Y-%m-%d %H:%M:%S")

# Deploy services
docker-compose -f docker-compose.yml up -d

# Record completed time and status
if [ $? -eq 0 ]; then
  completed_time=$(date "+%Y-%m-%d %H:%M:%S")
  status="Success"
else
  completed_time=""
  status="Failure"
fi

# Add deployment record to Google Sheet
curl -X POST -H "Content-Type: application/json" -d '{
  "values": [
    ["'$start_time'", "Service Name", "'$completed_time'", "'$status'"]
  ]
}' "https://sheets.googleapis.com/v4/spreadsheets/<spreadsheet-id>/values/A2:append?valueInputOption=USER_ENTERED&insertDataOption=INSERT_ROWS&access_token=<access-token>"
