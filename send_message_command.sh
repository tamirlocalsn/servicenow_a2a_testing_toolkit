#!/bin/bash
# ServiceNow Agent Message Command
# Generated on Wed Sep 24 09:48:28 EDT 2025

curl -X POST \
     -H "Content-Type: application/json" \
     -H "x-sn-apikey: now_ZoBtcHR0CzRx5DUcso53ExAuuxdzBGvRbjwePecOAplbsF6Ot0F9vKtu4o7lENI5laI4pB_B9ojxpFYml-8Dng" \
     -H "User-Agent: ServiceNow-A2A-Test/1.0" \
     -d '{
  "jsonrpc": "2.0",
  "method": "message/send",
  "params": {
    "message": {
      "role": "user",
      "parts": [
        {
          "kind": "text",
          "text": "Tell me about ServiceNow integrations"
        }
      ],
      "messageId": "e45415dfe3ae46ec88ca613d92a26e22",
      "kind": "user"
    },
    "context": {
      "contextId": null,
      "taskId": null
    },
    "metadata": {},
    "pushNotificationUrl": "http://localhost:8080/a2a/callback/test/a897091599a14c289dbe4715fb76c7b7",
    "id": "a897091599a14c289dbe4715fb76c7b7"
  },
  "id": "a897091599a14c289dbe4715fb76c7b7"
}' \
     "https://acnaccdemo.service-now.com/api/sn_aia/a2a/v1/agent/id/138d4b97878f66100b12a75d3fbb35f8"
