#!/usr/bin/env python3

import requests
import json
from uuid import uuid4

# Test with requests library to match curl exactly
API_KEY = "now_ZoBtcHR0CzRx5DUcso53ExAuuxdzBGvRbjwePecOAplbsF6Ot0F9vKtu4o7lENI5laI4pB_B9ojxpFYml-8Dng"
URL = "https://acnaccdemo.service-now.com/api/sn_aia/a2a/v1/agent/id/138d4b97878f66100b12a75d3fbb35f8"

# Create payload
request_id = uuid4().hex
message_id = uuid4().hex

payload = {
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
            "messageId": message_id,
            "kind": "user"
        },
        "context": {
            "contextId": None,
            "taskId": None
        },
        "metadata": {},
        "pushNotificationUrl": f"http://localhost:8080/a2a/callback/servicenow-docs-agent/{request_id}",
        "id": request_id
    },
    "id": request_id
}

# Exact headers that work with curl
headers = {
    'content-type': 'application/json',
    'x-sn-apikey': API_KEY,
    'user-agent': 'curl/8.7.1'
}

print("Testing with requests library...")
print(f"URL: {URL}")
print("Headers:")
for k, v in headers.items():
    print(f"  {k}: {v}")

try:
    response = requests.post(URL, json=payload, headers=headers, timeout=30)
    
    print(f"\nResponse Status: {response.status_code}")
    print("Response Headers:")
    for k, v in response.headers.items():
        print(f"  {k}: {v}")
    
    print(f"\nResponse Body: {response.text}")
    
    if response.status_code == 200:
        print("✅ SUCCESS with requests library!")
        data = response.json()
        print(json.dumps(data, indent=2))
    else:
        print(f"❌ Failed with status {response.status_code}")
        
except Exception as e:
    print(f"❌ Error: {e}")
