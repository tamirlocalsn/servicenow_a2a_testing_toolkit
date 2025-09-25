#!/bin/bash

# ServiceNow A2A Testing - Quick Start
# This script helps you get started quickly

set -e

echo "🚀 ServiceNow A2A Testing - Quick Start"
echo "======================================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "📋 Setting up configuration..."
    cp .env.template .env
    echo "✅ Created .env file from template"
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env file with your ServiceNow details:"
    echo "   - SERVICENOW_INSTANCE=your-instance.service-now.com"
    echo "   - SERVICENOW_AGENT_ID=your-agent-id"
    echo "   - SERVICENOW_TOKEN=your-api-key"
    echo ""
    echo "Then run this script again to continue."
    exit 0
fi

# Load configuration
source .env

# Validate configuration
if [ -z "$SERVICENOW_INSTANCE" ] || [ -z "$SERVICENOW_AGENT_ID" ] || [ -z "$SERVICENOW_TOKEN" ]; then
    echo "❌ Configuration incomplete. Please edit .env file with your ServiceNow details."
    exit 1
fi

echo "✅ Configuration loaded:"
echo "   Instance: $SERVICENOW_INSTANCE"
echo "   Agent ID: $SERVICENOW_AGENT_ID"
echo "   API Key: ${SERVICENOW_TOKEN:0:15}..."
echo ""

# Make scripts executable
chmod +x test_servicenow_agent.sh
chmod +x generate_curl_commands.sh

echo "🧪 Running quick test..."
echo ""

# Run the test
if ./test_servicenow_agent.sh --discovery-only; then
    echo ""
    echo "🎉 Quick test successful!"
    echo ""
    echo "📚 Next steps:"
    echo "   1. Run full test: ./test_servicenow_agent.sh"
    echo "   2. Try Python client: python generic_a2a_client.py"
    echo "   3. Generate curl commands: ./generate_curl_commands.sh"
    echo "   4. Read the guide: ServiceNow_A2A_Testing_Guide.md"
else
    echo ""
    echo "❌ Quick test failed. Please check your configuration and try again."
    echo ""
    echo "💡 Troubleshooting tips:"
    echo "   - Verify your ServiceNow instance URL"
    echo "   - Check that your agent ID is correct"
    echo "   - Ensure your API key has A2A permissions"
    echo "   - Try running with verbose output: ./test_servicenow_agent.sh -v"
fi
