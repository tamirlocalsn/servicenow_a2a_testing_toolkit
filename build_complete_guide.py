#!/usr/bin/env python3
"""
Build a comprehensive HTML guide that includes all ServiceNow A2A testing content
"""

import os
import re
from pathlib import Path

def read_file_content(file_path):
    """Read file content safely"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"Warning: Could not read {file_path}: {e}")
        return ""

def escape_html(text):
    """Escape HTML special characters"""
    return (text.replace('&', '&amp;')
                .replace('<', '&lt;')
                .replace('>', '&gt;')
                .replace('"', '&quot;')
                .replace("'", '&#x27;'))

def create_complete_html_guide():
    """Create the comprehensive HTML guide"""
    
    package_dir = Path("ServiceNow_A2A_Testing_Package_20250924_FINAL")
    if not package_dir.exists():
        package_dir = Path("ServiceNow_A2A_Testing_Package_20250924")
    
    if not package_dir.exists():
        print("❌ Package directory not found")
        return
    
    # Read source files
    readme_content = read_file_content(package_dir / "README.md")
    guide_content = read_file_content(package_dir / "ServiceNow_A2A_Testing_Guide.md")
    package_readme = read_file_content(package_dir / "PACKAGE_README.md")
    
    # Read script files
    python_client = read_file_content(package_dir / "generic_a2a_client.py")
    test_script = read_file_content(package_dir / "test_servicenow_agent.sh")
    curl_generator = read_file_content(package_dir / "generate_curl_commands.sh")
    examples_py = read_file_content(package_dir / "examples.py")
    env_template = read_file_content(package_dir / ".env.template")
    
    # Create the HTML content
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ServiceNow A2A Testing - Complete Guide</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f8f9fa;
        }}
        
        .container {{
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }}
        
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }}
        
        .header h1 {{
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 300;
        }}
        
        .nav {{
            background: #2c3e50;
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }}
        
        .nav ul {{
            list-style: none;
            display: flex;
            flex-wrap: wrap;
        }}
        
        .nav li {{
            flex: 1;
            min-width: 120px;
        }}
        
        .nav a {{
            display: block;
            padding: 15px 10px;
            color: white;
            text-decoration: none;
            text-align: center;
            border-right: 1px solid #34495e;
            transition: background 0.3s;
            font-size: 0.9em;
        }}
        
        .nav a:hover {{
            background: #34495e;
        }}
        
        .content {{
            padding: 40px;
        }}
        
        .section {{
            margin-bottom: 50px;
            padding-bottom: 30px;
            border-bottom: 1px solid #ecf0f1;
        }}
        
        h1, h2, h3 {{
            color: #2c3e50;
            margin-bottom: 20px;
        }}
        
        h1 {{
            font-size: 2.2em;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
        }}
        
        h2 {{
            font-size: 1.6em;
            margin-top: 30px;
            color: #34495e;
        }}
        
        h3 {{
            font-size: 1.3em;
            margin-top: 25px;
            color: #7f8c8d;
        }}
        
        .code-block {{
            background: #2c3e50;
            color: #ecf0f1;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            overflow-x: auto;
            position: relative;
            font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
            font-size: 0.85em;
            line-height: 1.4;
        }}
        
        .code-block::before {{
            content: attr(data-lang);
            position: absolute;
            top: 8px;
            right: 15px;
            background: #3498db;
            color: white;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 0.75em;
            font-weight: bold;
        }}
        
        .inline-code {{
            background: #ecf0f1;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'SF Mono', Monaco, monospace;
            font-size: 0.9em;
        }}
        
        .alert {{
            padding: 15px 20px;
            margin: 20px 0;
            border-radius: 5px;
            border-left: 4px solid;
        }}
        
        .alert-info {{
            background: #e3f2fd;
            border-color: #2196f3;
            color: #1565c0;
        }}
        
        .alert-success {{
            background: #e8f5e8;
            border-color: #4caf50;
            color: #2e7d32;
        }}
        
        .alert-warning {{
            background: #fff3e0;
            border-color: #ff9800;
            color: #ef6c00;
        }}
        
        .feature-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }}
        
        .feature-card {{
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #3498db;
        }}
        
        .step {{
            display: flex;
            align-items: flex-start;
            margin: 20px 0;
        }}
        
        .step-number {{
            display: inline-block;
            width: 30px;
            height: 30px;
            background: #3498db;
            color: white;
            border-radius: 50%;
            text-align: center;
            line-height: 30px;
            margin-right: 15px;
            font-weight: bold;
            flex-shrink: 0;
        }}
        
        table {{
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }}
        
        th, td {{
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }}
        
        th {{
            background: #3498db;
            color: white;
            font-weight: 600;
        }}
        
        .toc {{
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }}
        
        .toc ul {{
            list-style: none;
            padding-left: 0;
        }}
        
        .toc li {{
            margin: 8px 0;
        }}
        
        .toc a {{
            color: #3498db;
            text-decoration: none;
        }}
        
        .footer {{
            background: #2c3e50;
            color: white;
            padding: 30px;
            text-align: center;
        }}
        
        @media (max-width: 768px) {{
            .nav ul {{
                flex-direction: column;
            }}
            
            .content {{
                padding: 20px;
            }}
            
            .header {{
                padding: 20px;
            }}
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>ServiceNow A2A Testing</h1>
            <p>Complete Guide & Testing Toolkit</p>
            <p style="font-size: 0.9em; opacity: 0.8;">Universal • Production-Ready • Comprehensive</p>
        </div>
        
        <nav class="nav">
            <ul>
                <li><a href="#overview">Overview</a></li>
                <li><a href="#quickstart">Quick Start</a></li>
                <li><a href="#python-client">Python Client</a></li>
                <li><a href="#bash-scripts">Bash Scripts</a></li>
                <li><a href="#examples">Examples</a></li>
                <li><a href="#troubleshooting">Troubleshooting</a></li>
            </ul>
        </nav>
        
        <div class="content">
            <section id="overview" class="section">
                <h1>🎯 Overview</h1>
                
                <p>This comprehensive toolkit provides everything needed to test ServiceNow Agent-to-Agent (A2A) implementations. It includes production-ready tools, detailed instructions, and troubleshooting guides that work with any ServiceNow instance and agent.</p>
                
                <div class="feature-grid">
                    <div class="feature-card">
                        <h3>🔧 Universal Compatibility</h3>
                        <p>Works with any ServiceNow instance and agent. No hardcoded values or dependencies.</p>
                    </div>
                    <div class="feature-card">
                        <h3>🛠️ Multiple Testing Methods</h3>
                        <p>Python SDK, direct HTTP calls, and curl commands for different scenarios.</p>
                    </div>
                    <div class="feature-card">
                        <h3>📚 Complete Documentation</h3>
                        <p>Step-by-step instructions, code examples, and troubleshooting guides.</p>
                    </div>
                    <div class="feature-card">
                        <h3>🚀 Production Ready</h3>
                        <p>Error handling, configuration management, and conversation context support.</p>
                    </div>
                </div>
                
                <div class="alert alert-info">
                    <strong>Package Contents:</strong> Python A2A client, automated testing scripts, curl command generators, configuration templates, and comprehensive documentation.
                </div>
            </section>
            
            <section id="quickstart" class="section">
                <h1>🚀 Quick Start</h1>
                
                <div class="step">
                    <div class="step-number">1</div>
                    <div>
                        <h3>Install Dependencies</h3>
                        <div class="code-block" data-lang="bash">pip install httpx a2a-sdk</div>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">2</div>
                    <div>
                        <h3>Configure Environment</h3>
                        <p>Create a <span class="inline-code">.env</span> file with your ServiceNow details:</p>
                        <div class="code-block" data-lang="env">{escape_html(env_template)}</div>
                    </div>
                </div>
                
                <div class="step">
                    <div class="step-number">3</div>
                    <div>
                        <h3>Run Quick Test</h3>
                        <div class="code-block" data-lang="bash">./test_servicenow_agent.sh</div>
                        <p>Or test with Python:</p>
                        <div class="code-block" data-lang="bash">python generic_a2a_client.py</div>
                    </div>
                </div>
                
                <div class="alert alert-success">
                    <strong>Success!</strong> If the test passes, your ServiceNow A2A agent is working correctly and ready for integration.
                </div>
            </section>
            
            <section id="python-client" class="section">
                <h1>🐍 Python A2A Client</h1>
                
                <p>The generic Python client provides a production-ready interface for ServiceNow A2A integration.</p>
                
                <h2>Complete Source Code</h2>
                <div class="code-block" data-lang="python">{escape_html(python_client)}</div>
                
                <h2>Usage Examples</h2>
                <div class="code-block" data-lang="python">{escape_html(examples_py)}</div>
            </section>
            
            <section id="bash-scripts" class="section">
                <h1>📜 Bash Testing Scripts</h1>
                
                <h2>Automated Testing Script</h2>
                <p>Comprehensive testing with discovery, message sending, and response parsing:</p>
                <div class="code-block" data-lang="bash">{escape_html(test_script)}</div>
                
                <h2>Curl Command Generator</h2>
                <p>Generate ready-to-use curl commands for manual testing:</p>
                <div class="code-block" data-lang="bash">{escape_html(curl_generator)}</div>
            </section>
            
            <section id="examples" class="section">
                <h1>💡 Usage Examples</h1>
                
                <h2>Basic Python Usage</h2>
                <div class="code-block" data-lang="python">import asyncio
from generic_a2a_client import ServiceNowA2AClient

async def main():
    client = ServiceNowA2AClient()
    response = await client.connect_and_send("What can you help me with?")
    print(response)

asyncio.run(main())</div>
                
                <h2>Bash Script Testing</h2>
                <div class="code-block" data-lang="bash"># Full test with custom message
./test_servicenow_agent.sh -m "Tell me about ServiceNow integrations"

# Discovery only
./test_servicenow_agent.sh --discovery-only

# Verbose output for debugging
./test_servicenow_agent.sh -v</div>
                
                <h2>Manual Curl Commands</h2>
                <div class="code-block" data-lang="bash"># Generate curl commands
./generate_curl_commands.sh -m "Your test message"

# Use generated commands
./discovery_command.sh | jq
./send_message_command.sh | jq</div>
            </section>
            
            <section id="troubleshooting" class="section">
                <h1>🔧 Troubleshooting</h1>
                
                <h2>Common Issues</h2>
                
                <h3>Authentication Errors (401)</h3>
                <div class="alert alert-warning">
                    <strong>Problem:</strong> API key authentication fails
                    <br><strong>Solutions:</strong>
                    <ul>
                        <li>Verify API key is correct and not expired</li>
                        <li>Ensure API key has A2A permissions</li>
                        <li>Check ServiceNow instance URL format</li>
                        <li>Try regenerating the API key</li>
                    </ul>
                </div>
                
                <h3>Agent Not Found (404)</h3>
                <div class="alert alert-warning">
                    <strong>Problem:</strong> Agent discovery fails
                    <br><strong>Solutions:</strong>
                    <ul>
                        <li>Verify agent ID is correct</li>
                        <li>Ensure agent is published and active</li>
                        <li>Check discovery URL format</li>
                    </ul>
                </div>
                
                <h3>Connection Timeouts</h3>
                <div class="alert alert-warning">
                    <strong>Problem:</strong> Requests timeout or fail
                    <br><strong>Solutions:</strong>
                    <ul>
                        <li>Check network connectivity</li>
                        <li>Verify instance URL accessibility</li>
                        <li>Increase timeout values</li>
                        <li>Check firewall/proxy settings</li>
                    </ul>
                </div>
                
                <h2>Debug Commands</h2>
                <div class="code-block" data-lang="bash"># Test with verbose output
./test_servicenow_agent.sh -v

# Test discovery only
./test_servicenow_agent.sh --discovery-only

# Check raw responses
curl -v -H "x-sn-apikey: your-key" "your-discovery-url"</div>
            </section>
        </div>
        
        <div class="footer">
            <p><strong>ServiceNow A2A Testing Toolkit</strong></p>
            <p>Complete, Universal, Production-Ready</p>
        </div>
    </div>
</body>
</html>"""
    
    # Write the HTML file
    output_file = "ServiceNow_A2A_Complete_Guide.html"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"✅ Created comprehensive HTML guide: {output_file}")
    print(f"📄 File size: {os.path.getsize(output_file) / 1024:.1f} KB")
    print("🌐 Open in browser to view the complete guide")

if __name__ == "__main__":
    create_complete_html_guide()
