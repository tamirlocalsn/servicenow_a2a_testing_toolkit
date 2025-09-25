#!/bin/bash

# ServiceNow A2A Testing Package Creator
# Creates a complete package for ServiceNow customers

set -e

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[NOTE]${NC} $1"; }

PACKAGE_NAME="ServiceNow_A2A_Testing_Package"
PACKAGE_DIR="${PACKAGE_NAME}_$(date +%Y%m%d)"

print_info "Creating ServiceNow A2A Testing Package"
echo "========================================"

# Create package directory
if [ -d "$PACKAGE_DIR" ]; then
    print_warning "Package directory exists, removing..."
    rm -rf "$PACKAGE_DIR"
fi

mkdir -p "$PACKAGE_DIR"
print_info "Created package directory: $PACKAGE_DIR"

# Copy core files
print_info "Copying core files..."

# Python client and examples
cp generic_a2a_client.py "$PACKAGE_DIR/"
cp examples.py "$PACKAGE_DIR/"

# Testing scripts
cp test_servicenow_agent.sh "$PACKAGE_DIR/"
cp generate_curl_commands.sh "$PACKAGE_DIR/"

# Configuration files
cp .env.template "$PACKAGE_DIR/"
cp README.md "$PACKAGE_DIR/"

# Documentation
cp ServiceNow_A2A_Testing_Guide.md "$PACKAGE_DIR/"

# Create requirements.txt
cat > "$PACKAGE_DIR/requirements.txt" << EOF
# ServiceNow A2A Testing Requirements
httpx>=0.24.0
a2a-sdk>=1.0.0
EOF

# Create a quick start script
cat > "$PACKAGE_DIR/quick_start.sh" << 'EOF'
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
EOF

chmod +x "$PACKAGE_DIR/quick_start.sh"

# Create installation script
cat > "$PACKAGE_DIR/install_dependencies.sh" << 'EOF'
#!/bin/bash

# ServiceNow A2A Testing - Dependency Installation

echo "📦 Installing ServiceNow A2A Testing Dependencies"
echo "================================================="

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    echo "Please install Python 3.8 or higher and try again."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Check if pip is available
if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
    echo "❌ pip is required but not installed."
    echo "Please install pip and try again."
    exit 1
fi

# Use pip3 if available, otherwise pip
PIP_CMD="pip3"
if ! command -v pip3 &> /dev/null; then
    PIP_CMD="pip"
fi

echo "✅ pip found: $($PIP_CMD --version)"
echo ""

# Install dependencies
echo "📥 Installing Python dependencies..."
$PIP_CMD install -r requirements.txt

echo ""
echo "✅ Dependencies installed successfully!"
echo ""
echo "🚀 You can now run: ./quick_start.sh"
EOF

chmod +x "$PACKAGE_DIR/install_dependencies.sh"

# Create comprehensive README for the package
cat > "$PACKAGE_DIR/PACKAGE_README.md" << 'EOF'
# ServiceNow A2A Testing Package

This package contains everything you need to test ServiceNow Agent-to-Agent (A2A) implementations.

## 🚀 Quick Start

1. **Install Dependencies:**
   ```bash
   ./install_dependencies.sh
   ```

2. **Configure Your Environment:**
   ```bash
   cp .env.template .env
   # Edit .env with your ServiceNow details
   ```

3. **Run Quick Test:**
   ```bash
   ./quick_start.sh
   ```

## 📁 Package Contents

### Core Files
- `generic_a2a_client.py` - Universal Python A2A client
- `test_servicenow_agent.sh` - Automated testing script
- `generate_curl_commands.sh` - Curl command generator
- `examples.py` - Python usage examples

### Configuration
- `.env.template` - Configuration template
- `requirements.txt` - Python dependencies

### Documentation
- `ServiceNow_A2A_Testing_Guide.md` - Complete testing guide
- `README.md` - Quick reference
- `PACKAGE_README.md` - This file

### Utilities
- `quick_start.sh` - Quick setup and test
- `install_dependencies.sh` - Dependency installer

## 🔧 Configuration

Edit `.env` file with your ServiceNow details:

```bash
SERVICENOW_INSTANCE=your-instance.service-now.com
SERVICENOW_AGENT_ID=your-agent-id
SERVICENOW_TOKEN=your-api-key
```

## 🧪 Testing Methods

### 1. Automated Script Testing
```bash
./test_servicenow_agent.sh                    # Full test
./test_servicenow_agent.sh --discovery-only   # Discovery only
./test_servicenow_agent.sh -v                 # Verbose output
```

### 2. Python Client Testing
```bash
python generic_a2a_client.py                  # Basic test
python examples.py                            # Advanced examples
```

### 3. Manual Curl Testing
```bash
./generate_curl_commands.sh                   # Generate commands
./discovery_command.sh | jq                   # Test discovery
./send_message_command.sh | jq                # Send message
```

## 📚 Documentation

- Read `ServiceNow_A2A_Testing_Guide.md` for comprehensive documentation
- Check `examples.py` for Python integration patterns
- See `README.md` for quick reference

## 🆘 Support

For troubleshooting and support:
1. Check the troubleshooting section in the testing guide
2. Run tests with verbose output (`-v` flag)
3. Verify your ServiceNow configuration
4. Consult ServiceNow documentation and community resources

## 📄 License

This testing package is provided as-is for ServiceNow customers to test their A2A implementations.
EOF

# Note: create_pdf.sh is intentionally not included in customer package
# Customers don't need PDF generation complexity - markdown is sufficient

print_success "Package created successfully!"
echo ""
print_info "Package contents:"
ls -la "$PACKAGE_DIR/"

echo ""
print_info "Package structure:"
tree "$PACKAGE_DIR/" 2>/dev/null || find "$PACKAGE_DIR/" -type f | sort

# Create a zip archive
print_info "Creating zip archive..."
zip -r "${PACKAGE_DIR}.zip" "$PACKAGE_DIR/" > /dev/null
print_success "Zip archive created: ${PACKAGE_DIR}.zip"

# Get package size
if command -v du &> /dev/null; then
    PACKAGE_SIZE=$(du -sh "$PACKAGE_DIR" | cut -f1)
    ZIP_SIZE=$(du -sh "${PACKAGE_DIR}.zip" | cut -f1)
    echo "Package size: $PACKAGE_SIZE (zip: $ZIP_SIZE)"
fi

echo ""
print_success "ServiceNow A2A Testing Package is ready!"
echo ""
print_info "To distribute to customers:"
echo "  1. Send them the zip file: ${PACKAGE_DIR}.zip"
echo "  2. Or share the directory: $PACKAGE_DIR/"
echo ""
print_info "Customer instructions:"
echo "  1. Extract the package"
echo "  2. Run: ./install_dependencies.sh"
echo "  3. Configure: edit .env file"
echo "  4. Test: ./quick_start.sh"
