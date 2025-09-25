#!/bin/bash

# Generic ServiceNow A2A Agent Test Script
# This script generates and executes curl commands to test any ServiceNow agent

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Load configuration from .env file if it exists
if [ -f .env ]; then
    print_status "Loading configuration from .env file..."
    export $(grep -v '^#' .env | xargs)
fi

# Configuration variables with defaults
SERVICENOW_INSTANCE=${SERVICENOW_INSTANCE:-""}
SERVICENOW_AGENT_ID=${SERVICENOW_AGENT_ID:-""}
SERVICENOW_TOKEN=${SERVICENOW_TOKEN:-""}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Test a ServiceNow A2A agent using curl commands"
    echo ""
    echo "Configuration (via environment variables or .env file):"
    echo "  SERVICENOW_INSTANCE    ServiceNow instance (e.g., company.service-now.com)"
    echo "  SERVICENOW_AGENT_ID    Agent ID to test"
    echo "  SERVICENOW_TOKEN       ServiceNow API key"
    echo ""
    echo "Options:"
    echo "  -i, --instance INSTANCE    ServiceNow instance"
    echo "  -a, --agent-id AGENT_ID    Agent ID"
    echo "  -t, --token TOKEN          API token"
    echo "  -m, --message MESSAGE      Custom message to send (default: test message)"
    echo "  -d, --discovery-only       Only test agent discovery, don't send message"
    echo "  -v, --verbose              Verbose output"
    echo "  -h, --help                 Show this help"
    echo ""
    echo "Examples:"
    echo "  $0  # Use .env file configuration"
    echo "  $0 -i company.service-now.com -a agent-id -t api-key"
    echo "  $0 -m \"What can you help me with?\" -v"
    echo "  $0 --discovery-only  # Only test discovery"
}

# Parse command line arguments
CUSTOM_MESSAGE=""
DISCOVERY_ONLY=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--instance)
            SERVICENOW_INSTANCE="$2"
            shift 2
            ;;
        -a|--agent-id)
            SERVICENOW_AGENT_ID="$2"
            shift 2
            ;;
        -t|--token)
            SERVICENOW_TOKEN="$2"
            shift 2
            ;;
        -m|--message)
            CUSTOM_MESSAGE="$2"
            shift 2
            ;;
        -d|--discovery-only)
            DISCOVERY_ONLY=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate required configuration
if [ -z "$SERVICENOW_INSTANCE" ]; then
    print_error "SERVICENOW_INSTANCE is required"
    show_usage
    exit 1
fi

if [ -z "$SERVICENOW_AGENT_ID" ]; then
    print_error "SERVICENOW_AGENT_ID is required"
    show_usage
    exit 1
fi

if [ -z "$SERVICENOW_TOKEN" ]; then
    print_error "SERVICENOW_TOKEN is required"
    show_usage
    exit 1
fi

# Set default message if not provided
if [ -z "$CUSTOM_MESSAGE" ]; then
    CUSTOM_MESSAGE="Hello! This is a test message. What can you help me with?"
fi

# Build URLs
BASE_URL="https://${SERVICENOW_INSTANCE}/api/sn_aia/a2a/id"
DISCOVERY_URL="${BASE_URL}/${SERVICENOW_AGENT_ID}/well_known/agent_json"
INVOCATION_URL="https://${SERVICENOW_INSTANCE}/api/sn_aia/a2a/v1/agent/id/${SERVICENOW_AGENT_ID}"

# Generate unique IDs
REQUEST_ID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')
MESSAGE_ID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')

print_status "ServiceNow A2A Agent Test"
echo "=================================="
echo "Instance: $SERVICENOW_INSTANCE"
echo "Agent ID: $SERVICENOW_AGENT_ID"
echo "API Key:  ${SERVICENOW_TOKEN:0:15}..."
echo "Message:  $CUSTOM_MESSAGE"
echo "=================================="

# Test 1: Agent Discovery
print_status "Step 1: Testing agent discovery..."
echo ""

if [ "$VERBOSE" = true ]; then
    print_status "Discovery URL: $DISCOVERY_URL"
    echo ""
fi

DISCOVERY_RESPONSE=$(curl -s -w "\n%{http_code}" \
    -H "Content-Type: application/json" \
    -H "x-sn-apikey: $SERVICENOW_TOKEN" \
    -H "User-Agent: ServiceNow-A2A-Test/1.0" \
    "$DISCOVERY_URL")

# Extract HTTP status code (last line) and response body
HTTP_STATUS=$(echo "$DISCOVERY_RESPONSE" | tail -n 1)
DISCOVERY_BODY=$(echo "$DISCOVERY_RESPONSE" | sed '$d')

if [ "$HTTP_STATUS" = "200" ]; then
    print_success "Agent discovery successful!"
    
    # Parse agent info
    AGENT_NAME=$(echo "$DISCOVERY_BODY" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('name', 'Unknown'))" 2>/dev/null || echo "Unknown")
    AGENT_DESC=$(echo "$DISCOVERY_BODY" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('description', 'No description'))" 2>/dev/null || echo "No description")
    
    echo "  Agent Name: $AGENT_NAME"
    echo "  Description: $AGENT_DESC"
    
    if [ "$VERBOSE" = true ]; then
        echo ""
        print_status "Full agent card response:"
        echo "$DISCOVERY_BODY" | python3 -m json.tool 2>/dev/null || echo "$DISCOVERY_BODY"
    fi
else
    print_error "Agent discovery failed! HTTP Status: $HTTP_STATUS"
    echo "Response: $DISCOVERY_BODY"
    exit 1
fi

echo ""

# Exit if discovery-only mode
if [ "$DISCOVERY_ONLY" = true ]; then
    print_success "Discovery-only mode completed successfully!"
    exit 0
fi

# Test 2: Send Message
print_status "Step 2: Sending test message to agent..."
echo ""

# Create JSON payload
JSON_PAYLOAD=$(cat <<EOF
{
  "jsonrpc": "2.0",
  "method": "message/send",
  "params": {
    "message": {
      "role": "user",
      "parts": [
        {
          "kind": "text",
          "text": "$CUSTOM_MESSAGE"
        }
      ],
      "messageId": "$MESSAGE_ID",
      "kind": "user"
    },
    "context": {
      "contextId": null,
      "taskId": null
    },
    "metadata": {},
    "pushNotificationUrl": "http://localhost:8080/a2a/callback/test/$REQUEST_ID",
    "id": "$REQUEST_ID"
  },
  "id": "$REQUEST_ID"
}
EOF
)

if [ "$VERBOSE" = true ]; then
    print_status "Invocation URL: $INVOCATION_URL"
    print_status "Request payload:"
    echo "$JSON_PAYLOAD" | python3 -m json.tool
    echo ""
fi

MESSAGE_RESPONSE=$(curl -s -w "\n%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -H "x-sn-apikey: $SERVICENOW_TOKEN" \
    -H "User-Agent: ServiceNow-A2A-Test/1.0" \
    -d "$JSON_PAYLOAD" \
    "$INVOCATION_URL")

# Extract HTTP status code (last line) and response body
HTTP_STATUS=$(echo "$MESSAGE_RESPONSE" | tail -n 1)
MESSAGE_BODY=$(echo "$MESSAGE_RESPONSE" | sed '$d')

if [ "$HTTP_STATUS" = "200" ]; then
    print_success "Message sent successfully!"
    echo ""
    
    # Extract and display agent response
    print_status "Agent Response:"
    
    # Try to extract the agent's text response
    AGENT_RESPONSES=$(echo "$MESSAGE_BODY" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    result = data.get('result', {})
    status = result.get('status', {})
    message = status.get('message', {})
    parts = message.get('parts', [])
    
    for i, part in enumerate(parts):
        if part.get('kind') == 'text':
            print(f'Response {i+1}: {part.get(\"text\", \"\")}')
except:
    print('Could not parse agent response')
" 2>/dev/null)

    if [ -n "$AGENT_RESPONSES" ]; then
        echo "$AGENT_RESPONSES"
    else
        print_warning "Could not extract agent response text"
    fi
    
    if [ "$VERBOSE" = true ]; then
        echo ""
        print_status "Full response:"
        echo "$MESSAGE_BODY" | python3 -m json.tool 2>/dev/null || echo "$MESSAGE_BODY"
    fi
else
    print_error "Message sending failed! HTTP Status: $HTTP_STATUS"
    echo "Response: $MESSAGE_BODY"
    exit 1
fi

echo ""
print_success "All tests completed successfully!"

# Generate curl commands for manual testing
echo ""
print_status "Manual curl commands for testing:"
echo ""
echo "# 1. Test agent discovery:"
echo "curl -H \"Content-Type: application/json\" \\"
echo "     -H \"x-sn-apikey: $SERVICENOW_TOKEN\" \\"
echo "     -H \"User-Agent: ServiceNow-A2A-Test/1.0\" \\"
echo "     \"$DISCOVERY_URL\""
echo ""
echo "# 2. Send message to agent:"
echo "curl -X POST \\"
echo "     -H \"Content-Type: application/json\" \\"
echo "     -H \"x-sn-apikey: $SERVICENOW_TOKEN\" \\"
echo "     -H \"User-Agent: ServiceNow-A2A-Test/1.0\" \\"
echo "     -d '$JSON_PAYLOAD' \\"
echo "     \"$INVOCATION_URL\""
