#!/usr/bin/env python3

import asyncio
import requests
import json
import os
from uuid import uuid4
from pathlib import Path

# Load environment variables from .env file if it exists
env_file = Path(__file__).parent / '.env'
if env_file.exists():
    with open(env_file) as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                key, value = line.strip().split('=', 1)
                os.environ[key] = value

# ServiceNow configuration
BASE_URL = "https://acnaccdemo.service-now.com/api/sn_aia/a2a/id"
AGENT_ID = "138d4b97878f66100b12a75d3fbb35f8"   # ServiceNow Docs Agent
AGENT_CARD_URL = f"{BASE_URL}/{AGENT_ID}/well_known/agent_json"  # Fixed URL pattern
AGENT_INVOCATION_URL = f"https://acnaccdemo.service-now.com/api/sn_aia/a2a/v1/agent/id/{AGENT_ID}"
X_SN_API_KEY = os.getenv("SERVICENOW_TOKEN")


def fetch_agent_card():
    """Fetch Agent Card from ServiceNow discovery endpoint"""
    try:
        print(f"Fetching agent card from: {AGENT_CARD_URL}")
        
        headers = {
            'content-type': 'application/json',
            'x-sn-apikey': X_SN_API_KEY,
            'user-agent': 'curl/8.7.1'
        }
        
        response = requests.get(AGENT_CARD_URL, headers=headers, timeout=30)
        response.raise_for_status()
        
        agent_card = response.json()
        print("✅ Agent card fetched successfully!")
        print(f"Agent: {agent_card.get('name', 'Unknown')}")
        print(f"Description: {agent_card.get('description', 'No description')}")
        
        return agent_card
        
    except Exception as e:
        print(f"❌ Error fetching agent card: {e}")
        raise


def create_message_body():
    """Create the message body with correct ServiceNow format"""
    request_id = uuid4().hex
    message_id = uuid4().hex
    
    message_body = {
        "jsonrpc": "2.0",
        "method": "message/send",  # Correct method for ServiceNow
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
                "kind": "user"  # Required field for ServiceNow
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
    
    return message_body


def send_message(message_body):
    """Send message to ServiceNow agent"""
    try:
        print("Sending message to ServiceNow agent...")
        print(f"Message: {message_body['params']['message']['parts'][0]['text']}")
        
        headers = {
            'content-type': 'application/json',
            'x-sn-apikey': X_SN_API_KEY,
            'user-agent': 'curl/8.7.1'
        }
        
        response = requests.post(AGENT_INVOCATION_URL, json=message_body, headers=headers, timeout=30)
        response.raise_for_status()
        
        response_data = response.json()
        print("✅ Message sent successfully!")
        
        # Extract and display the agent's response
        if 'result' in response_data and 'status' in response_data['result']:
            status = response_data['result']['status']
            if 'message' in status and 'parts' in status['message']:
                for part in status['message']['parts']:
                    if part.get('kind') == 'text':
                        print(f"\n🤖 ServiceNow Docs Agent Response:")
                        print(f"{part['text']}")
                        print()
        
        return response_data
        
    except Exception as e:
        print(f"❌ Error sending message: {e}")
        raise


def main():
    """Main function to run the A2A client"""
    print("=== ServiceNow A2A Client (Working Requests Version) ===")
    
    # Check if API key is loaded
    if not X_SN_API_KEY:
        print("❌ ERROR: SERVICENOW_TOKEN environment variable not set!")
        print("Please set the API key in the .env file")
        return 1
    
    print(f"✅ API key loaded: {X_SN_API_KEY[:15]}...")
    
    try:
        # Step 1: Fetch agent card (discovery)
        print("\n1. Discovering ServiceNow agent...")
        agent_card = fetch_agent_card()
        
        # Step 2: Create message
        print("\n2. Creating message...")
        message_body = create_message_body()
        
        # Step 3: Send message (invocation)
        print("\n3. Invoking ServiceNow agent...")
        response = send_message(message_body)
        
        print("\n✅ A2A Client completed successfully!")
        
    except Exception as e:
        print(f"\n❌ A2A Client failed: {e}")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())
