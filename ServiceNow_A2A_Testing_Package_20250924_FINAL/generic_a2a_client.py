#!/usr/bin/env python3
"""
Generic ServiceNow A2A Client

A configurable client for connecting to any ServiceNow Agent-to-Agent (A2A) endpoint.
Supports both environment variables and direct configuration.

Usage:
    # Using environment variables
    export SERVICENOW_INSTANCE="your-instance.service-now.com"
    export SERVICENOW_AGENT_ID="your-agent-id"
    export SERVICENOW_TOKEN="your-api-key"
    python generic_a2a_client.py

    # Or configure directly in code
    client = ServiceNowA2AClient(
        instance="your-instance.service-now.com",
        agent_id="your-agent-id", 
        api_key="your-api-key"
    )
    await client.send_message("Your message here")
"""

import asyncio
from uuid import uuid4
import httpx 
import os
from pathlib import Path
from typing import Optional, Dict, Any
from dataclasses import dataclass

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
    SendMessageRequest,
    MessageSendParams,
)


@dataclass
class ServiceNowConfig:
    """Configuration for ServiceNow A2A client"""
    instance: str  # e.g., "your-instance.service-now.com"
    agent_id: str  # ServiceNow agent ID
    api_key: str   # ServiceNow API key
    
    @property
    def base_url(self) -> str:
        """Base URL for A2A API"""
        return f"https://{self.instance}/api/sn_aia/a2a/id"
    
    @property
    def discovery_url(self) -> str:
        """Agent discovery URL"""
        return f"{self.base_url}/{self.agent_id}/well_known/agent_json"
    
    @classmethod
    def from_env(cls) -> 'ServiceNowConfig':
        """Create configuration from environment variables"""
        instance = os.getenv("SERVICENOW_INSTANCE")
        agent_id = os.getenv("SERVICENOW_AGENT_ID") 
        api_key = os.getenv("SERVICENOW_TOKEN")
        
        if not instance:
            raise ValueError("SERVICENOW_INSTANCE environment variable is required")
        if not agent_id:
            raise ValueError("SERVICENOW_AGENT_ID environment variable is required")
        if not api_key:
            raise ValueError("SERVICENOW_TOKEN environment variable is required")
            
        return cls(instance=instance, agent_id=agent_id, api_key=api_key)


class ServiceNowA2AClient:
    """Generic ServiceNow A2A Client"""
    
    def __init__(self, instance: str = None, agent_id: str = None, api_key: str = None):
        """
        Initialize the ServiceNow A2A client
        
        Args:
            instance: ServiceNow instance (e.g., "your-instance.service-now.com")
            agent_id: ServiceNow agent ID
            api_key: ServiceNow API key
            
        If parameters are None, will attempt to load from environment variables.
        """
        if instance and agent_id and api_key:
            self.config = ServiceNowConfig(instance=instance, agent_id=agent_id, api_key=api_key)
        else:
            self.config = ServiceNowConfig.from_env()
        
        self.agent_card: Optional[AgentCard] = None
        self.a2a_client: Optional[A2AClient] = None
    
    async def fetch_agent_card(self, httpx_client: httpx.AsyncClient) -> AgentCard:
        """Fetch agent card from ServiceNow discovery endpoint"""
        try:
            print(f"🔍 Discovering agent at: {self.config.instance}")
            print(f"📋 Agent ID: {self.config.agent_id}")
            print(f"🌐 Discovery URL: {self.config.discovery_url}")
            
            headers = {
                'content-type': 'application/json',
                'x-sn-apikey': self.config.api_key,
                'user-agent': 'ServiceNow-A2A-Client/1.0'
            }
            
            response = await httpx_client.get(self.config.discovery_url, headers=headers)
            response.raise_for_status()
            
            agent_card_data = response.json()
            agent_card = AgentCard(**agent_card_data)
            
            print("✅ Agent discovered successfully!")
            print(f"📝 Name: {agent_card.name}")
            print(f"📄 Description: {agent_card.description}")
            print(f"🔗 Invocation URL: {agent_card.url}")
            
            self.agent_card = agent_card
            return agent_card

        except httpx.HTTPStatusError as e:
            print(f"❌ HTTP Error {e.response.status_code}: {e.response.text}")
            raise RuntimeError(f"Failed to fetch agent card: HTTP {e.response.status_code}")
        except Exception as e:
            print(f"❌ Error fetching agent card: {e}")
            raise RuntimeError(f"Failed to fetch agent card: {e}")

    def initialize_client(self, httpx_client: httpx.AsyncClient) -> A2AClient:
        """Initialize A2A client with the discovered agent card"""
        if not self.agent_card:
            raise RuntimeError("Agent card not fetched. Call fetch_agent_card() first.")
        
        client = A2AClient(
            httpx_client=httpx_client, 
            agent_card=self.agent_card
        )
        print("✅ A2A Client initialized")
        
        self.a2a_client = client
        return client

    def create_message_body(self, message_text: str, context_id: str = None, task_id: str = None) -> Dict[str, Any]:
        """
        Create message body for ServiceNow A2A communication
        
        Args:
            message_text: The message to send to the agent
            context_id: Optional context ID for conversation continuity
            task_id: Optional task ID for task tracking
        """
        request_id = uuid4().hex
        message_id = uuid4().hex
        
        message_body = {
            'message': {
                'role': 'user',
                'parts': [
                    {'kind': 'text', 'text': message_text}
                ],
                'messageId': message_id,
                'kind': 'message'  # SDK expects 'message'
            },
            'context': {
                'contextId': context_id,
                'taskId': task_id
            },
            'metadata': {},
            'pushNotificationUrl': f"http://localhost:8080/a2a/callback/{self.config.agent_id}/{request_id}",
            'id': request_id
        }

        return message_body

    async def send_message(self, message_text: str, context_id: str = None, task_id: str = None) -> Dict[str, Any]:
        """
        Send a message to the ServiceNow agent
        
        Args:
            message_text: The message to send
            context_id: Optional context ID for conversation continuity
            task_id: Optional task ID for task tracking
            
        Returns:
            The agent's response as a dictionary
        """
        if not self.a2a_client:
            raise RuntimeError("A2A client not initialized. Call initialize_client() first.")
        
        print(f"💬 Sending message: {message_text}")
        
        message_body = self.create_message_body(message_text, context_id, task_id)
        
        request = SendMessageRequest(
            id=str(uuid4()), 
            params=MessageSendParams(**message_body)
        )

        try:
            response = await self.a2a_client.send_message(request)
            print("✅ Message sent successfully!")
            
            # Extract and display agent response in a user-friendly way
            if hasattr(response, 'result') and response.result:
                result = response.result
                if hasattr(result, 'status') and result.status:
                    status = result.status
                    if hasattr(status, 'message') and status.message:
                        message = status.message
                        if hasattr(message, 'parts') and message.parts:
                            print("\n🤖 Agent Response:")
                            for part in message.parts:
                                if hasattr(part, 'text'):
                                    print(f"   {part.text}")
                            print()
            
            return response.model_dump(mode='json', exclude_none=True)
            
        except Exception as e:
            print(f"❌ Error sending message: {e}")
            raise

    async def connect_and_send(self, message_text: str, context_id: str = None, task_id: str = None) -> Dict[str, Any]:
        """
        Convenience method to connect to agent and send a message in one call
        
        Args:
            message_text: The message to send
            context_id: Optional context ID for conversation continuity
            task_id: Optional task ID for task tracking
            
        Returns:
            The agent's response as a dictionary
        """
        timeout = httpx.Timeout(30.0, connect=10.0)
        
        async with httpx.AsyncClient(timeout=timeout) as httpx_client:
            await self.fetch_agent_card(httpx_client)
            self.initialize_client(httpx_client)
            return await self.send_message(message_text, context_id, task_id)


async def main():
    """Example usage of the generic ServiceNow A2A client"""
    print("=== Generic ServiceNow A2A Client ===")
    
    try:
        # Option 1: Use environment variables
        client = ServiceNowA2AClient()
        
        # Option 2: Direct configuration (uncomment to use)
        # client = ServiceNowA2AClient(
        #     instance="your-instance.service-now.com",
        #     agent_id="your-agent-id",
        #     api_key="your-api-key"
        # )
        
        print(f"🏢 Instance: {client.config.instance}")
        print(f"🤖 Agent ID: {client.config.agent_id}")
        print(f"🔑 API Key: {client.config.api_key[:15]}...")
        
        # Send a message to the agent
        message = "What can you help me with?"
        response = await client.connect_and_send(message)
        
        print("\n✅ A2A Client completed successfully!")
        
    except ValueError as e:
        print(f"❌ Configuration Error: {e}")
        print("\nRequired environment variables:")
        print("  SERVICENOW_INSTANCE=your-instance.service-now.com")
        print("  SERVICENOW_AGENT_ID=your-agent-id")
        print("  SERVICENOW_TOKEN=your-api-key")
        
    except Exception as e:
        print(f"❌ A2A Client failed: {e}")
        print(f"Error type: {type(e).__name__}")


if __name__ == "__main__":
    asyncio.run(main())
