#!/usr/bin/env python3
"""
ServiceNow A2A Client

A client for connecting to ServiceNow Agent-to-Agent (A2A) endpoints.
Supports environment variables and direct configuration.

Usage:
    # Using environment variables
    # Create a .env file with:
    # SERVICENOW_INSTANCE=your-instance.service-now.com
    # SERVICENOW_AGENT_ID=your-agent-id
    # SERVICENOW_TOKEN=your-api-key
    
    # Run the client
    python generic_a2a_client.py
"""

import asyncio
import os
import json
import logging
import httpx
from uuid import uuid4
from typing import Dict, Any, Optional
from dataclasses import dataclass
from pathlib import Path
from dotenv import load_dotenv
from a2a.client import A2AClient
from a2a.types import AgentCard, Message, SendMessageRequest, MessageSendParams

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables from .env file
def load_environment():
    # Look for .env file in current directory and parent directories
    current_dir = Path(__file__).parent.absolute()
    env_path = None
    
    # Check current directory and parent directories
    for path in [current_dir, current_dir.parent]:
        env_file = path / '.env'
        if env_file.exists():
            env_path = env_file
            break
    
    if env_path:
        logger.info(f"Loading environment from: {env_path}")
        load_dotenv(env_path)
    else:
        logger.warning("No .env file found in current or parent directories")

# Load environment variables
load_environment()

@dataclass
class ServiceNowConfig:
    """Configuration for ServiceNow A2A client"""
    instance: str  # e.g., "your-instance.service-now.com"
    agent_id: str  # ServiceNow agent ID
    api_key: str   # ServiceNow API key
    
    @classmethod
    def from_env(cls) -> 'ServiceNowConfig':
        """Create configuration from environment variables"""
        instance = os.getenv("SERVICENOW_INSTANCE")
        agent_id = os.getenv("SERVICENOW_AGENT_ID")
        api_key = os.getenv("SERVICENOW_TOKEN")
        
        if not all([instance, agent_id, api_key]):
            raise ValueError(
                "Missing required environment variables. Please set:\n"
                "- SERVICENOW_INSTANCE\n"
                "- SERVICENOW_AGENT_ID\n"
                "- SERVICENOW_TOKEN"
            )
            
        return cls(instance=instance, agent_id=agent_id, api_key=api_key)

class ServiceNowA2AClient:
    """ServiceNow A2A Client"""
    
    def __init__(self, instance: str = None, agent_id: str = None, api_key: str = None):
        """
        Initialize the ServiceNow A2A client
        
        Args:
            instance: ServiceNow instance (e.g., "your-instance.service-now.com")
            agent_id: ServiceNow agent ID
            api_key: ServiceNow API key
        """
        # Load from parameters or environment variables
        self.config = ServiceNowConfig(
            instance=instance or os.getenv("SERVICENOW_INSTANCE"),
            agent_id=agent_id or os.getenv("SERVICENOW_AGENT_ID"),
            api_key=api_key or os.getenv("SERVICENOW_TOKEN")
        )
        
        # Log the configuration (without exposing the full API key)
        logger.info(f"Configuration loaded - Instance: {self.config.instance}, Agent ID: {self.config.agent_id}")
        
        if not all([self.config.instance, self.config.agent_id, self.config.api_key]):
            raise ValueError(
                "Missing required configuration. Please provide:\n"
                "- SERVICENOW_INSTANCE\n"
                "- SERVICENOW_AGENT_ID\n"
                "- SERVICENOW_TOKEN\n"
                "Either pass these as parameters or set them in the .env file."
            )

        # Initialize HTTP client settings
        self.timeout = httpx.Timeout(30.0, connect=10.0)
        self.agent_card_url = f"https://{self.config.instance}/api/sn_aia/a2a/id/{self.config.agent_id}/well_known/agent_json"
        
    async def _get_agent_card(self, client: httpx.AsyncClient) -> AgentCard:
        """Fetch the agent card from ServiceNow."""
        try:
            headers = {
                'content-type': 'application/json',
                'x-sn-apikey': self.config.api_key,
                'user-agent': 'python-a2a-client/1.0'
            }
            
            logger.info(f"Fetching agent card from: {self.agent_card_url}")
            response = await client.get(self.agent_card_url, headers=headers)
            response.raise_for_status()
            
            agent_card_data = response.json()
            agent_card = AgentCard(**agent_card_data)
            
            logger.info(f"Agent card loaded: {agent_card.name}")
            logger.debug(f"Agent details: {agent_card}")
            
            return agent_card
        except Exception as e:
            logger.error(f"Failed to fetch agent card: {str(e)}")
            raise

    async def send_message(self, message: str) -> Dict[str, Any]:
        """
        Send a message to the ServiceNow agent
        
        Args:
            message: The message text to send
            
        Returns:
            Dict containing the response from the agent
        """
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            try:
                # Get the agent card
                agent_card = await self._get_agent_card(client)
                
                # Initialize A2A client
                a2a_client = A2AClient(
                    httpx_client=client,
                    agent_card=agent_card
                )
                
                # Create message body
                request_id = uuid4().hex
                message_body = {
                    'message': {
                        'role': 'user',
                        'parts': [{'kind': 'text', 'text': message}],
                        'messageId': uuid4().hex,
                        'kind': 'message'
                    },
                    'context': {
                        'contextId': None,
                        'taskId': None
                    },
                    'metadata': {},
                    'pushNotificationUrl': f"http://localhost:8080/a2a/callback/{self.config.agent_id}/{request_id}",
                    'id': request_id
                }
                
                # Create and send the request
                request = SendMessageRequest(
                    id=str(uuid4()),
                    params=MessageSendParams(**message_body)
                )
                
                logger.info(f"Sending message: {message}")
                response = await a2a_client.send_message(request)
                
                # Convert response to dict if needed
                if hasattr(response, 'model_dump'):
                    return response.model_dump(mode='json', exclude_none=True)
                return dict(response) if hasattr(response, '__dict__') else str(response)
                
            except Exception as e:
                logger.error(f"Error sending message: {str(e)}", exc_info=True)
                return {
                    "error": str(e),
                    "error_type": type(e).__name__,
                    "config": {
                        "instance": self.config.instance,
                        "agent_id": self.config.agent_id,
                        "api_key": f"{self.config.api_key[:5]}..." if self.config.api_key else None
                    }
                }

    async def connect_and_send(self, message: str) -> Dict[str, Any]:
        """Send a message to the ServiceNow agent."""
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            try:
                # Get the agent card
                agent_card = await self._get_agent_card(client)
                
                # Initialize A2A client with additional headers
                client = httpx.AsyncClient(
                    base_url=f"https://{self.config.instance}",
                    headers={
                        'Content-Type': 'application/json',
                        'x-sn-apikey': self.config.api_key,
                        'user-agent': 'python-a2a-client/1.0'
                    },
                    timeout=self.timeout
                )
                
                # Create message body
                request_id = uuid4().hex
                message_body = {
                    "jsonrpc": "2.0",
                    "method": "message/send",
                    "id": request_id,
                    "params": {
                        "message": {
                            "role": "user",
                            "parts": [{"kind": "text", "text": message}],
                            "messageId": uuid4().hex,
                            "kind": "message"
                        },
                        "context": {
                            "contextId": None,
                            "taskId": None
                        },
                        "metadata": {},
                        "pushNotificationUrl": f"http://localhost:8080/a2a/callback/{self.config.agent_id}/{request_id}"
                    }
                }
                
                logger.info(f"Sending message: {message}")
                url = f"/api/sn_aia/a2a/v1/agent/id/{self.config.agent_id}"
                response = await client.post(url, json=message_body)
                response.raise_for_status()
                
                return response.json()
                
            except httpx.HTTPStatusError as e:
                logger.error(f"HTTP error: {e.response.status_code} - {e.response.text}")
                return {
                    "error": f"HTTP {e.response.status_code}",
                    "details": e.response.text,
                    "status_code": e.response.status_code
                }
            except Exception as e:
                logger.error(f"Error sending message: {str(e)}", exc_info=True)
                return {
                    "error": str(e),
                    "error_type": type(e).__name__,
                    "config": {
                        "instance": self.config.instance,
                        "agent_id": self.config.agent_id,
                        "api_key": f"{self.config.api_key[:5]}..." if self.config.api_key else None
                    }
                }
            finally:
                await client.aclose()

async def main():
    """Example usage of the ServiceNow A2A client"""
    print("=== ServiceNow A2A Client ===")
    
    try:
        # Initialize client with environment variables from .env
        client = ServiceNowA2AClient()
        
        # Test message
        test_message = "What can you help me with?"
        print(f"Sending test message: {test_message}")
        
        # Send message and get response
        response = await client.send_message(test_message)
        
        # Print the response
        print("\n=== Agent Response ===")
        print(json.dumps(response, indent=2))
        print("=====================")
        
    except Exception as e:
        print(f"Error: {str(e)}")
        print(f"Error type: {type(e).__name__}")
        return 1
    
    return 0

if __name__ == "__main__":
    asyncio.run(main())
