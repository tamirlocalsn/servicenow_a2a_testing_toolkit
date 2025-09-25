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
