#!/bin/bash

# ServiceNow A2A Agent Invocation Test with curl
# Based on the successful request structure you provided

API_KEY="now_ZoBtcHR0CzRx5DUcso53ExAuuxdzBGvRbjwePecOAplbsF6Ot0F9vKtu4o7lENI5laI4pB_B9ojxpFYml-8Dng"
AGENT_URL="https://acnaccdemo.service-now.com/api/sn_aia/a2a/v1/agent/id/138d4b97878f66100b12a75d3fbb35f8"
REQUEST_ID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')
MESSAGE_ID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')

echo "Testing ServiceNow A2A Agent with curl..."
echo "Request ID: $REQUEST_ID"
echo "Message ID: $MESSAGE_ID"
echo "Agent URL: $AGENT_URL"
echo ""

# Create the JSON payload matching your successful request structure
curl -X POST "$AGENT_URL" \
  -H "Content-Type: application/json" \
  -H "x-sn-apikey: $API_KEY" \
  -d '{
    "jsonrpc": "2.0",
    "method": "message/send",
    "params": {
      "message": {
        "role": "user",
        "parts": [
          {
            "kind": "text",
            "text": "What can ServiceNow Docs Agent help me with?"
          }
        ],
        "messageId": "'$MESSAGE_ID'",
        "kind": "user"
      },
      "context": {
        "contextId": null,
        "taskId": null
      },
      "metadata": {},
      "pushNotificationUrl": "http://localhost:8080/a2a/callback/servicenow-docs-agent/'$REQUEST_ID'",
      "id": "'$REQUEST_ID'"
    },
    "id": "'$REQUEST_ID'"
  }' \
  -v

echo ""
echo "Curl test completed."
