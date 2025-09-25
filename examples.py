#!/usr/bin/env python3
"""
Examples of using the Generic ServiceNow A2A Client

This file demonstrates various ways to use the generic client
for different use cases and integration patterns.
"""

import asyncio
import httpx
from generic_a2a_client import ServiceNowA2AClient


async def example_1_simple_usage():
    """Example 1: Simple one-shot message"""
    print("=" * 60)
    print("EXAMPLE 1: Simple Usage")
    print("=" * 60)
    
    try:
        client = ServiceNowA2AClient()
        response = await client.connect_and_send("What services do you provide?")
        print("✅ Simple message sent successfully!")
        return response
    except Exception as e:
        print(f"❌ Error: {e}")
        return None


async def example_2_direct_configuration():
    """Example 2: Direct configuration without environment variables"""
    print("\n" + "=" * 60)
    print("EXAMPLE 2: Direct Configuration")
    print("=" * 60)
    
    try:
        # This would work with any ServiceNow instance
        client = ServiceNowA2AClient(
            instance="your-instance.service-now.com",  # Replace with your instance
            agent_id="your-agent-id-here",  # Replace with your agent ID
            api_key="your-api-key-here"  # Replace with your API key
        )
        
        response = await client.connect_and_send("How can you assist me today?")
        print("✅ Direct configuration worked!")
        return response
    except Exception as e:
        print(f"❌ Error: {e}")
        return None


async def example_3_conversation_with_context():
    """Example 3: Multi-turn conversation with context"""
    print("\n" + "=" * 60)
    print("EXAMPLE 3: Conversation with Context")
    print("=" * 60)
    
    try:
        client = ServiceNowA2AClient()
        
        # First message
        print("👤 User: What documentation topics do you cover?")
        response1 = await client.connect_and_send("What documentation topics do you cover?")
        
        # Extract context ID for conversation continuity
        context_id = None
        if response1 and 'result' in response1:
            context_id = response1['result'].get('contextId')
        
        if context_id:
            print(f"🔗 Using context ID: {context_id}")
            
            # Follow-up message with context
            print("👤 User: Tell me more about the first topic you mentioned")
            response2 = await client.connect_and_send(
                "Tell me more about the first topic you mentioned",
                context_id=context_id
            )
            
            print("✅ Contextual conversation completed!")
            return response1, response2
        else:
            print("⚠️ No context ID received, continuing without context")
            return response1, None
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return None, None


async def example_4_step_by_step_control():
    """Example 4: Step-by-step control for advanced usage"""
    print("\n" + "=" * 60)
    print("EXAMPLE 4: Step-by-Step Control")
    print("=" * 60)
    
    try:
        client = ServiceNowA2AClient()
        
        timeout = httpx.Timeout(30.0, connect=10.0)
        async with httpx.AsyncClient(timeout=timeout) as httpx_client:
            # Step 1: Discover the agent
            print("🔍 Step 1: Discovering agent...")
            agent_card = await client.fetch_agent_card(httpx_client)
            
            # Step 2: Initialize the A2A client
            print("🔧 Step 2: Initializing A2A client...")
            a2a_client = client.initialize_client(httpx_client)
            
            # Step 3: Send multiple messages
            print("💬 Step 3: Sending multiple messages...")
            
            messages = [
                "What is your primary function?",
                "How accurate is your information?",
                "What should I do if I can't find what I'm looking for?"
            ]
            
            responses = []
            for i, message in enumerate(messages, 1):
                print(f"   Message {i}: {message}")
                response = await client.send_message(message)
                responses.append(response)
            
            print("✅ Step-by-step control completed!")
            return responses
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return None


async def example_5_error_handling():
    """Example 5: Demonstrating error handling"""
    print("\n" + "=" * 60)
    print("EXAMPLE 5: Error Handling")
    print("=" * 60)
    
    # Test with invalid configuration
    try:
        print("🧪 Testing with invalid agent ID...")
        client = ServiceNowA2AClient(
            instance="your-instance.service-now.com",
            agent_id="invalid-agent-id",
            api_key="your-api-key-here"
        )
        
        response = await client.connect_and_send("This should fail")
        print("⚠️ Unexpected success - this should have failed!")
        return response
        
    except Exception as e:
        print(f"✅ Expected error caught: {type(e).__name__}: {e}")
        print("   This demonstrates proper error handling")
        return None


async def main():
    """Run all examples"""
    print("🚀 ServiceNow A2A Client Examples")
    print("This demonstrates various usage patterns of the generic client\n")
    
    # Run all examples
    await example_1_simple_usage()
    await example_2_direct_configuration()
    await example_3_conversation_with_context()
    await example_4_step_by_step_control()
    await example_5_error_handling()
    
    print("\n" + "=" * 60)
    print("🎉 All examples completed!")
    print("=" * 60)
    print("\nTo use this client in your own code:")
    print("1. Copy generic_a2a_client.py to your project")
    print("2. Configure your .env file or use direct configuration")
    print("3. Import and use: from generic_a2a_client import ServiceNowA2AClient")


if __name__ == "__main__":
    asyncio.run(main())
