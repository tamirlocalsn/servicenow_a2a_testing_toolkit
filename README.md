# ServiceNow A2A Testing Toolkit

A comprehensive testing toolkit for ServiceNow Agent-to-Agent (A2A) implementations. This toolkit provides everything needed to test, validate, and integrate with ServiceNow A2A agents across any ServiceNow instance.

## 🎯 What's Included

- 🐍 **Python A2A Client** - Complete generic client with full source code
- 📜 **Bash Testing Scripts** - Automated testing using curl commands
- 🌐 **HTML Documentation** - Complete interactive guide with copy-paste examples
- 🔧 **Configuration Templates** - Ready-to-use environment and configuration files
- 🚀 **Usage Examples** - Python, Bash, and curl implementation patterns
- 🛠️ **Troubleshooting Guide** - Common issues and proven solutions

## ✨ Key Features

- ✅ **Universal Compatibility**: Works with any ServiceNow instance and agent
- ✅ **Multiple Testing Methods**: Python SDK, direct HTTP calls, and curl commands
- ✅ **Robust Implementation**: Comprehensive error handling and validation
- ✅ **Complete Documentation**: Step-by-step guides with interactive examples
- ✅ **Copy-Paste Ready**: All code snippets are immediately usable
- ✅ **Conversation Context**: Support for multi-turn conversations

## Quick Start

### 1. Install Dependencies

```bash
pip install httpx a2a-sdk
```

### 2. Configure Your ServiceNow Connection

**Option A: Using Environment Variables (Recommended)**

Copy the template and fill in your values:
```bash
cp .env.template .env
# Edit .env with your ServiceNow details
```

**Option B: Direct Configuration in Code**

```python
from generic_a2a_client import ServiceNowA2AClient

client = ServiceNowA2AClient(
    instance="your-instance.service-now.com",
    agent_id="your-agent-id",
    api_key="your-api-key"
)
```

### 3. Send a Message

```python
import asyncio
from generic_a2a_client import ServiceNowA2AClient

async def main():
    client = ServiceNowA2AClient()
    response = await client.connect_and_send("What can you help me with?")
    print(response)

asyncio.run(main())
```

## Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `SERVICENOW_INSTANCE` | Your ServiceNow instance URL (without https://) | `company.service-now.com` |
| `SERVICENOW_AGENT_ID` | The ID of the agent you want to connect to | `138d4b97878f66100b12a75d3fbb35f8` |
| `SERVICENOW_TOKEN` | Your ServiceNow API key | `your-api-key-here` |

### Finding Your Agent ID

1. Log into your ServiceNow instance
2. Navigate to **AI Agent Studio** → **Create and Manage**
3. Select the **AI Agents** tab
4. Select your desired agent
5. Copy the Agent ID from the URL after `agent-setup`

**Example:** In URL `https://your-instance.service-now.com/now/agent-studio/agent-setup/9a170dc52b403a149675f1cfe291bfac/params/...`  
Agent ID is: `9a170dc52b403a149675f1cfe291bfac`

### Getting an API Key

1. Navigate to **System Web Services** → **API Access Policies** → **REST API Key**
2. Create a new API Key
3. Assign it to the **a2aauthscope** scope
4. Save and copy the generated API key

### Configuring API Key Access

To allow your API Key to access the A2A API:

1. Go to **System Web Services** → **API Access Policies** → **Inbound Authentication Profile**
2. Create API Key authentication profile with **Header** auth parameter
3. Go to **System Web Services** → **API Access Policies** → **REST API Access Policies**
4. Select **AI Agent A2A API Access Policy**
5. Add your API Key profile to **Inbound authentication profiles**

## Usage Examples

### Basic Usage

```python
import asyncio
from generic_a2a_client import ServiceNowA2AClient

async def basic_example():
    client = ServiceNowA2AClient()
    response = await client.connect_and_send("Hello, agent!")
    return response

asyncio.run(basic_example())
```

### Advanced Usage with Context

```python
import asyncio
from generic_a2a_client import ServiceNowA2AClient

async def conversation_example():
    client = ServiceNowA2AClient()
    
    # Start a conversation
    response1 = await client.connect_and_send("What services do you provide?")
    
    # Continue the conversation with context
    context_id = response1.get('result', {}).get('contextId')
    response2 = await client.connect_and_send(
        "Tell me more about the first one", 
        context_id=context_id
    )
    
    return response1, response2

asyncio.run(conversation_example())
```

### Step-by-Step Control

```python
import asyncio
import httpx
from generic_a2a_client import ServiceNowA2AClient

async def detailed_example():
    client = ServiceNowA2AClient()
    
    timeout = httpx.Timeout(30.0, connect=10.0)
    async with httpx.AsyncClient(timeout=timeout) as httpx_client:
        # Step 1: Discover the agent
        agent_card = await client.fetch_agent_card(httpx_client)
        
        # Step 2: Initialize the A2A client
        a2a_client = client.initialize_client(httpx_client)
        
        # Step 3: Send multiple messages
        response1 = await client.send_message("First message")
        response2 = await client.send_message("Second message")
        
        return response1, response2

asyncio.run(detailed_example())
```

## API Reference

### ServiceNowA2AClient

#### Constructor
```python
ServiceNowA2AClient(instance=None, agent_id=None, api_key=None)
```

If parameters are None, loads configuration from environment variables.

#### Methods

##### `connect_and_send(message_text, context_id=None, task_id=None)`
Convenience method to connect and send a message in one call.

##### `fetch_agent_card(httpx_client)`
Discover and fetch the agent card from ServiceNow.

##### `initialize_client(httpx_client)`
Initialize the A2A client with the discovered agent.

##### `send_message(message_text, context_id=None, task_id=None)`
Send a message to the agent.

## Error Handling

The client provides detailed error messages for common issues:

- **Configuration errors**: Missing environment variables
- **Connection errors**: Network or authentication issues
- **Agent errors**: Invalid agent ID or unavailable agent
- **Message errors**: Invalid message format or sending failures

## 📚 Complete Documentation

This toolkit includes comprehensive HTML documentation with interactive examples:

- **[📋 Overview & Quick Start](ServiceNow_A2A_Complete_Index.html)** - Main landing page with complete guide
- **[🐍 Python A2A Client](ServiceNow_A2A_Python_Client.html)** - Complete Python client with source code
- **[📜 Bash Testing Scripts](ServiceNow_A2A_Bash_Scripts.html)** - Automated testing scripts
- **[💡 Usage Examples](ServiceNow_A2A_Examples.html)** - Python, Bash, and curl examples
- **[🔧 Troubleshooting Guide](ServiceNow_A2A_Troubleshooting.html)** - Common issues and solutions

### GitHub Pages

The complete documentation is available as GitHub Pages at: `https://[username].github.io/[repository-name]/ServiceNow_A2A_Complete_Index.html`

## 📁 Repository Structure

```
├── README.md                              # This file
├── ServiceNow_A2A_Complete_Index.html     # Main documentation landing page
├── ServiceNow_A2A_Overview.aspx           # SharePoint-compatible overview
├── ServiceNow_A2A_Python_Client.html      # Python client documentation
├── ServiceNow_A2A_Bash_Scripts.html       # Bash scripts documentation  
├── ServiceNow_A2A_Examples.html           # Usage examples
├── ServiceNow_A2A_Troubleshooting.html    # Troubleshooting guide
├── ServiceNow_A2A_Testing_Package_20250924/
│   ├── generic_a2a_client.py              # Main Python client
│   ├── test_servicenow_agent.sh           # Automated testing script
│   ├── generate_curl_commands.sh          # Curl command generator
│   ├── .env.template                      # Configuration template
│   └── README.md                          # Package-specific documentation
└── _config.yml                           # GitHub Pages configuration
```

## Migration from Specific Implementations

If you have an existing ServiceNow A2A client, you can easily migrate:

1. Replace hardcoded instance/agent values with configuration
2. Use the `ServiceNowA2AClient` class instead of direct implementation
3. Update your `.env` file with the new variable names

## Contributing

Feel free to submit issues and enhancement requests!
