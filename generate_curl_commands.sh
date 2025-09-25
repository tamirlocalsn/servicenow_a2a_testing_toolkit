#!/bin/bash

# ServiceNow A2A Curl Command Generator
# Generates ready-to-use curl commands for testing ServiceNow agents

set -e

# Color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[NOTE]${NC} $1"
}

# Load configuration from .env file if it exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Configuration
SERVICENOW_INSTANCE=${SERVICENOW_INSTANCE:-"your-instance.service-now.com"}
SERVICENOW_AGENT_ID=${SERVICENOW_AGENT_ID:-"your-agent-id"}
SERVICENOW_TOKEN=${SERVICENOW_TOKEN:-"your-api-key"}

# Parse command line arguments
CUSTOM_MESSAGE="What can you help me with?"

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
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Generate curl commands for testing ServiceNow A2A agents"
            echo ""
            echo "Options:"
            echo "  -i, --instance INSTANCE    ServiceNow instance"
            echo "  -a, --agent-id AGENT_ID    Agent ID"
            echo "  -t, --token TOKEN          API token"
            echo "  -m, --message MESSAGE      Custom message"
            echo "  -h, --help                 Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Build URLs
BASE_URL="https://${SERVICENOW_INSTANCE}/api/sn_aia/a2a/id"
DISCOVERY_URL="${BASE_URL}/${SERVICENOW_AGENT_ID}/well_known/agent_json"
INVOCATION_URL="https://${SERVICENOW_INSTANCE}/api/sn_aia/a2a/v1/agent/id/${SERVICENOW_AGENT_ID}"

# Generate unique IDs
REQUEST_ID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')
MESSAGE_ID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')

print_info "ServiceNow A2A Curl Command Generator"
echo "======================================"
echo "Instance: $SERVICENOW_INSTANCE"
echo "Agent ID: $SERVICENOW_AGENT_ID"
echo "Message:  $CUSTOM_MESSAGE"
echo "======================================"
echo ""

print_success "Generated Curl Commands:"
echo ""

# 1. Discovery Command
print_info "1. Agent Discovery Command:"
echo ""
cat << EOF
curl -H "Content-Type: application/json" \\
     -H "x-sn-apikey: $SERVICENOW_TOKEN" \\
     -H "User-Agent: ServiceNow-A2A-Test/1.0" \\
     "$DISCOVERY_URL"
EOF

echo ""
echo ""

# 2. Message Sending Command
print_info "2. Send Message Command:"
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

cat << EOF
curl -X POST \\
     -H "Content-Type: application/json" \\
     -H "x-sn-apikey: $SERVICENOW_TOKEN" \\
     -H "User-Agent: ServiceNow-A2A-Test/1.0" \\
     -d '$JSON_PAYLOAD' \\
     "$INVOCATION_URL"
EOF

echo ""
echo ""

# 3. One-liner versions
print_info "3. One-liner Commands (copy-paste ready):"
echo ""

echo "# Discovery:"
echo "curl -H \"Content-Type: application/json\" -H \"x-sn-apikey: $SERVICENOW_TOKEN\" -H \"User-Agent: ServiceNow-A2A-Test/1.0\" \"$DISCOVERY_URL\""
echo ""

echo "# Send Message:"
echo "curl -X POST -H \"Content-Type: application/json\" -H \"x-sn-apikey: $SERVICENOW_TOKEN\" -H \"User-Agent: ServiceNow-A2A-Test/1.0\" -d '$JSON_PAYLOAD' \"$INVOCATION_URL\""
echo ""

# 4. Save to files
print_info "4. Saving commands to files..."

# Save discovery command
cat > discovery_command.sh << EOF
#!/bin/bash
# ServiceNow Agent Discovery Command
# Generated on $(date)

curl -H "Content-Type: application/json" \\
     -H "x-sn-apikey: $SERVICENOW_TOKEN" \\
     -H "User-Agent: ServiceNow-A2A-Test/1.0" \\
     "$DISCOVERY_URL"
EOF

# Save message command
cat > send_message_command.sh << EOF
#!/bin/bash
# ServiceNow Agent Message Command
# Generated on $(date)

curl -X POST \\
     -H "Content-Type: application/json" \\
     -H "x-sn-apikey: $SERVICENOW_TOKEN" \\
     -H "User-Agent: ServiceNow-A2A-Test/1.0" \\
     -d '$JSON_PAYLOAD' \\
     "$INVOCATION_URL"
EOF

chmod +x discovery_command.sh send_message_command.sh

print_success "Commands saved to:"
echo "  - discovery_command.sh"
echo "  - send_message_command.sh"
echo ""

print_warning "Usage Tips:"
echo "  - Run './discovery_command.sh' to test agent discovery"
echo "  - Run './send_message_command.sh' to send a message"
echo "  - Pipe output to 'jq' for pretty JSON formatting"
echo "  - Example: ./discovery_command.sh | jq"
