import asyncio
from uuid import uuid4
import httpx 
import os
from pathlib import Path

# Load environment variables from .env file if it exists
env_file = Path(__file__).parent / '.env'
if env_file.exists():
    with open(env_file) as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                key, value = line.strip().split('=', 1)
                os.environ[key] = value

from a2a.client import A2AClient
from a2a.types import (
    AgentCard,
    Message,
    Role,
    Part,
    TextPart,
    SendMessageRequest,
    MessageSendParams,
)

BASE_URL = "https://acnaccdemo.service-now.com/api/sn_aia/a2a/id"
AGENT_ID = "138d4b97878f66100b12a75d3fbb35f8"   # This ID is for `ServiceNow Docs Agent` 
# Fixed: Use ServiceNow-specific discovery URL pattern
AGENT_CARD_URL = f"{BASE_URL}/{AGENT_ID}/well_known/agent_json"
X_SN_API_KEY = os.getenv("SERVICENOW_TOKEN")


async def fetch_agent_card(httpx_client) -> AgentCard:
    # Fixed: Direct HTTP call instead of A2ACardResolver (which doesn't work with ServiceNow)
    try:
        print(f"Fetching agent card from ServiceNow: {AGENT_CARD_URL}")
        
        # Fixed: Use working httpx configuration - pass headers per request
        headers = {
            'content-type': 'application/json',
            'x-sn-apikey': X_SN_API_KEY,
            'user-agent': 'curl/8.7.1'
        }
        
        response = await httpx_client.get(AGENT_CARD_URL, headers=headers)
        response.raise_for_status()
        
        agent_card_data = response.json()
        agent_card = AgentCard(**agent_card_data)
        
        print("✅ Agent card fetched successfully!")
        print(f"Agent: {agent_card.name}")
        print(f"Description: {agent_card.description}")
        print(f"Invocation URL: {agent_card.url}")
        
        return agent_card

    except Exception as e:
        print(f"❌ Error fetching agent card: {e}")
        raise RuntimeError("Failed to fetch agent card!")


def initialize_client(httpx_client, agent_card) -> A2AClient:
    # Initialize A2A Client
    client = A2AClient(
        httpx_client=httpx_client, agent_card=agent_card
    )
    print("✅ A2AClient initialized")

    return client


def create_message_body():
    # Fixed: Add required ServiceNow fields and use SDK-compatible format
    request_id = uuid4().hex
    message_body = {
        'message': {
            'role': 'user',
            'parts': [
                {'kind': 'text', 'text': 'What can ServiceNow Docs Agent help me with?'}
            ],
            'messageId': uuid4().hex,
            'kind': 'message'  # Fixed: SDK expects 'message', not 'user'
        },
        # Fixed: Add required ServiceNow fields
        'context': {
            'contextId': None,
            'taskId': None
        },
        'metadata': {},
        'pushNotificationUrl': f"http://localhost:8080/a2a/callback/servicenow-docs-agent/{request_id}",
        'id': request_id
    }

    return message_body


async def send_message(message_body, a2a_client):
    # Send the request
    request = SendMessageRequest(
        id=str(uuid4()), params=MessageSendParams(**message_body)
    )
    print("Sending message using A2A SDK...")
    print(f"Message: {message_body['message']['parts'][0]['text']}")

    # Retrieve response
    try:
        response = await a2a_client.send_message(request)
        print("✅ Message sent successfully using SDK!")
        print(response.model_dump(mode='json', exclude_none=True))
    except Exception as e:
        print(f"❌ Error sending message: {e}")
        raise


async def main() -> None:
    print("=== ServiceNow A2A Client (Fixed Original Code) ===")
    
    # Fixed: Add API key validation
    if not X_SN_API_KEY:
        print("❌ ERROR: SERVICENOW_TOKEN environment variable not set!")
        print("Please set the API key in the .env file")
        return
    
    print(f"✅ API key loaded: {X_SN_API_KEY[:15]}...")
    
    # Fixed: Don't set headers at client level - pass them per request
    timeout = httpx.Timeout(30.0, connect=10.0)
    
    async with httpx.AsyncClient(timeout=timeout) as httpx_client:
        try:
            print("\n1. Fetching agent card...")
            agent_card = await fetch_agent_card(httpx_client)
            
            print("\n2. Initializing A2A client...")
            a2a_client = initialize_client(httpx_client, agent_card)
            
            print("\n3. Creating message...")
            message_body = create_message_body()
            
            print("\n4. Sending message to ServiceNow agent...")
            await send_message(message_body, a2a_client)
            
            print("\n✅ A2A Client completed successfully!")
            
        except Exception as e:
            print(f"\n❌ A2A Client failed: {e}")
            print(f"Error type: {type(e).__name__}")
            raise


if __name__ == "__main__":
    asyncio.run(main())
