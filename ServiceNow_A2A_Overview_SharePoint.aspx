<%@ Page Language="C#" MasterPageFile="~masterurl/default.master" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<asp:Content ID="PageHead" ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ServiceNow A2A Testing - Overview & Quick Start</title>
    <style type="text/css">
        .sn-a2a-container {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #323130;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #ffffff;
        }
        
        .sn-a2a-header {
            background: linear-gradient(90deg, #0078d4 0%, #106ebe 100%);
            color: white;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .sn-a2a-header h1 {
            font-size: 2.5em;
            margin: 0 0 10px 0;
            font-weight: 300;
        }
        
        .sn-a2a-nav-links {
            background: #f3f2f1;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: center;
        }
        
        .sn-a2a-nav-links a {
            display: inline-block;
            margin: 5px 10px;
            padding: 10px 20px;
            background: #0078d4;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
        }
        
        .sn-a2a-nav-links a:hover {
            background: #106ebe;
        }
        
        .sn-a2a-feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin: 25px 0;
        }
        
        .sn-a2a-feature-card {
            background: #f3f2f1;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #0078d4;
        }
        
        .sn-a2a-feature-card h3 {
            color: #323130;
            margin-top: 0;
        }
        
        .sn-a2a-code-block {
            background: #1e1e1e;
            color: #d4d4d4;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            overflow-x: auto;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 0.9em;
            line-height: 1.4;
            position: relative;
        }
        
        .sn-a2a-code-block::before {
            content: attr(data-lang);
            position: absolute;
            top: 8px;
            right: 60px;
            background: #0078d4;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75em;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .sn-a2a-copy-btn {
            position: absolute;
            top: 8px;
            right: 8px;
            background: #323130;
            color: white;
            border: 1px solid #605e5c;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75em;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .sn-a2a-copy-btn:hover {
            background: #484644;
        }
        
        .sn-a2a-copy-btn.copied {
            background: #107c10;
            border-color: #107c10;
        }
        
        .sn-a2a-alert {
            padding: 15px 20px;
            margin: 20px 0;
            border-radius: 6px;
            border-left: 4px solid;
        }
        
        .sn-a2a-alert-info {
            background: #deecf9;
            border-color: #0078d4;
            color: #004578;
        }
        
        .sn-a2a-alert-success {
            background: #dff6dd;
            border-color: #107c10;
            color: #0b5a0b;
        }
        
        .sn-a2a-step {
            display: flex;
            align-items: flex-start;
            margin: 20px 0;
            padding: 15px;
            background: #faf9f8;
            border-radius: 8px;
        }
        
        .sn-a2a-step-number {
            display: inline-block;
            width: 32px;
            height: 32px;
            background: #0078d4;
            color: white;
            border-radius: 50%;
            text-align: center;
            line-height: 32px;
            margin-right: 15px;
            font-weight: bold;
            flex-shrink: 0;
        }
        
        .sn-a2a-step-content {
            flex: 1;
        }
        
        .sn-a2a-step-content h3 {
            margin-top: 0;
            margin-bottom: 10px;
            color: #323130;
        }
        
        .sn-a2a-container h1, 
        .sn-a2a-container h2, 
        .sn-a2a-container h3 {
            color: #323130;
        }
        
        .sn-a2a-container h1 {
            font-size: 2.2em;
            border-bottom: 3px solid #0078d4;
            padding-bottom: 10px;
        }
        
        .sn-a2a-inline-code {
            background: #f3f2f1;
            padding: 2px 6px;
            border-radius: 4px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 0.9em;
            color: #a31621;
        }
        
        .sn-a2a-table {
            width: 100%; 
            border-collapse: collapse; 
            margin: 20px 0; 
            border: 1px solid #edebe9;
        }
        
        .sn-a2a-table thead tr {
            background: #0078d4; 
            color: white;
        }
        
        .sn-a2a-table th, 
        .sn-a2a-table td {
            padding: 12px; 
            text-align: left; 
            border-bottom: 1px solid #edebe9;
        }
    </style>
</asp:Content>

<asp:Content ID="Main" ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <div class="sn-a2a-container">
        <div class="sn-a2a-header">
            <h1>ServiceNow A2A Testing</h1>
            <p>Overview & Quick Start Guide</p>
        </div>
        
        <div class="sn-a2a-nav-links">
            <strong>📚 Complete Guide Series:</strong><br>
            <a href="#current">1. Overview & Quick Start</a>
            <a href="ServiceNow_A2A_Python_Client.aspx">2. Python Client</a>
            <a href="ServiceNow_A2A_Bash_Scripts.aspx">3. Bash Scripts</a>
            <a href="ServiceNow_A2A_Examples.aspx">4. Examples</a>
            <a href="ServiceNow_A2A_Troubleshooting.aspx">5. Troubleshooting</a>
        </div>
        
        <section>
            <h1>🎯 Overview</h1>
            
            <p>This comprehensive toolkit provides everything needed to test ServiceNow Agent-to-Agent (A2A) implementations. It includes robust tools, detailed instructions, and troubleshooting guides that work with <strong>any ServiceNow instance and agent</strong>.</p>
            
            <div class="sn-a2a-feature-grid">
                <div class="sn-a2a-feature-card">
                    <h3>🔧 Universal Compatibility</h3>
                    <p>Works with any ServiceNow instance and agent. No hardcoded values or dependencies.</p>
                </div>
                <div class="sn-a2a-feature-card">
                    <h3>🛠️ Multiple Testing Methods</h3>
                    <p>Python SDK, direct HTTP calls, and curl commands for different scenarios.</p>
                </div>
                <div class="sn-a2a-feature-card">
                    <h3>📚 Complete Documentation</h3>
                    <p>Step-by-step instructions, code examples, and troubleshooting guides.</p>
                </div>
                <div class="sn-a2a-feature-card">
                    <h3>🚀 Robust Implementation</h3>
                    <p>Comprehensive error handling, configuration management, and conversation context support.</p>
                </div>
            </div>
            
            <div class="sn-a2a-alert sn-a2a-alert-info">
                <strong>What's Included:</strong> Python A2A client, automated testing scripts, curl command generators, configuration templates, and comprehensive documentation.
            </div>
        </section>
        
        <section>
            <h1>🚀 Quick Start</h1>
            
            <div class="sn-a2a-step">
                <div class="sn-a2a-step-number">1</div>
                <div class="sn-a2a-step-content">
                    <h3>Install Dependencies</h3>
                    <p>Install the required Python packages:</p>
                    <div class="sn-a2a-code-block" data-lang="bash">
                        <button class="sn-a2a-copy-btn" onclick="copyCode(this)">Copy</button>
                        <pre>pip install httpx a2a-sdk</pre>
                    </div>
                </div>
            </div>
            
            <div class="sn-a2a-step">
                <div class="sn-a2a-step-number">2</div>
                <div class="sn-a2a-step-content">
                    <h3>Configure Environment</h3>
                    <p>Create a <span class="sn-a2a-inline-code">.env</span> file with your ServiceNow details:</p>
                    <div class="sn-a2a-code-block" data-lang="env">
                        <button class="sn-a2a-copy-btn" onclick="copyCode(this)">Copy</button>
                        <pre># ServiceNow A2A Client Configuration Template
# Copy this file to .env and fill in your values

# ServiceNow Instance (without https://)
# Example: your-company.service-now.com
SERVICENOW_INSTANCE=your-instance.service-now.com

# ServiceNow Agent ID
# This is the unique identifier for the agent you want to connect to
# You can find this in the ServiceNow agent configuration
SERVICENOW_AGENT_ID=your-agent-id-here

# ServiceNow API Key
# Generate this in ServiceNow under System Web Services > REST API Explorer
# or in the ServiceNow developer portal
SERVICENOW_TOKEN=your-api-key-here</pre>
                    </div>
                    <h3>Run Quick Test</h3>
                    <p>Test your configuration with the automated script:</p>
                    <div class="sn-a2a-code-block" data-lang="bash">
                        <button class="sn-a2a-copy-btn" onclick="copyCode(this)">Copy</button>
                        <pre>./test_servicenow_agent.sh</pre>
                    </div>
                    <p>Or test with Python:</p>
                    <div class="sn-a2a-code-block" data-lang="bash">
                        <button class="sn-a2a-copy-btn" onclick="copyCode(this)">Copy</button>
                        <pre>python generic_a2a_client.py</pre>
                    </div>
                </div>
            </div>
            
            <div class="sn-a2a-alert sn-a2a-alert-success">
                <strong>Success!</strong> If the test passes, your ServiceNow A2A agent is working correctly and ready for integration.
            </div>
        </section>
        
        <section>
            <h1>⚙️ Configuration Details</h1>
            
            <h2>Environment Variables</h2>
            <table class="sn-a2a-table">
                <thead>
                    <tr>
                        <th>Variable</th>
                        <th>Description</th>
                        <th>Example</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><span class="sn-a2a-inline-code">SERVICENOW_INSTANCE</span></td>
                        <td>Your ServiceNow instance URL (without https://)</td>
                        <td>company.service-now.com</td>
                    </tr>
                    <tr>
                        <td><span class="sn-a2a-inline-code">SERVICENOW_AGENT_ID</span></td>
                        <td>The ID of the agent you want to connect to</td>
                        <td>your-agent-id-here</td>
                    </tr>
                    <tr>
                        <td><span class="sn-a2a-inline-code">SERVICENOW_TOKEN</span></td>
                        <td>Your ServiceNow API key</td>
                        <td>your-api-key-here</td>
                    </tr>
                </tbody>
            </table>
            
            <h2>Finding Your Agent ID</h2>
            <ol>
                <li>Log into your ServiceNow instance</li>
                <li>Navigate to <strong>AI Agent Studio</strong> → <strong>Create and Manage</strong></li>
                <li>Select the <strong>AI Agents</strong> tab</li>
                <li>Select your desired agent</li>
                <li>Copy the Agent ID from the URL after <span class="sn-a2a-inline-code">agent-setup</span></li>
            </ol>
            <p><strong>Example:</strong> In URL <span class="sn-a2a-inline-code">https://your-instance.service-now.com/now/agent-studio/agent-setup/9a170dc52b403a149675f1cfe291bfac/params/...</span><br>
            Agent ID is: <span class="sn-a2a-inline-code">9a170dc52b403a149675f1cfe291bfac</span></p>
            
            <h2>Generating an API Key</h2>
            <ol>
                <li>In ServiceNow, navigate to <strong>System Web Services</strong> → <strong>API Access Policies</strong> → <strong>REST API Key</strong></li>
                <li>Create a new API Key</li>
                <li>Assign it to the <strong>a2aauthscope</strong> scope</li>
                <li>Save and copy the generated API key</li>
            </ol>
            
            <h2>Configuring API Key Access for A2A</h2>
            <p>To allow your API Key to access the A2A API, you need to configure authentication profiles:</p>
            
            <h3>Step 1: Create API Key Authentication Profile</h3>
            <ol>
                <li>Go to <strong>System Web Services</strong> → <strong>API Access Policies</strong> → <strong>Inbound Authentication Profile</strong></li>
                <li>Select <strong>Create API Key authentication profiles</strong></li>
                <li>Provide a name for your profile</li>
                <li>Select <strong>Header</strong> for API Key for auth parameter field</li>
                <li>Save the profile</li>
            </ol>
            
            <h3>Step 2: Add Profile to A2A API Access Policy</h3>
            <ol>
                <li>Go to <strong>System Web Services</strong> → <strong>API Access Policies</strong> → <strong>REST API Access Policies</strong></li>
                <li>Select <strong>AI Agent A2A API Access Policy</strong></li>
                <li>Add your newly created API Key profile to the list of <strong>Inbound authentication profiles</strong></li>
                <li>Save the policy</li>
            </ol>
        </section>
        
        <div class="sn-a2a-nav-links">
            <strong>Next:</strong> <a href="ServiceNow_A2A_Python_Client.aspx">Python Client Guide →</a>
        </div>
    </div>

    <script type="text/javascript">
        function copyCode(button) {
            var codeBlock = button.parentElement;
            var code = codeBlock.querySelector('pre').textContent;
            
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(code).then(function() {
                    button.textContent = 'Copied!';
                    button.classList.add('copied');
                    
                    setTimeout(function() {
                        button.textContent = 'Copy';
                        button.classList.remove('copied');
                    }, 2000);
                }).catch(function(err) {
                    console.error('Failed to copy: ', err);
                    button.textContent = 'Error';
                    setTimeout(function() {
                        button.textContent = 'Copy';
                    }, 2000);
                });
            } else {
                // Fallback for older browsers
                var textArea = document.createElement("textarea");
                textArea.value = code;
                document.body.appendChild(textArea);
                textArea.focus();
                textArea.select();
                try {
                    document.execCommand('copy');
                    button.textContent = 'Copied!';
                    button.classList.add('copied');
                    setTimeout(function() {
                        button.textContent = 'Copy';
                        button.classList.remove('copied');
                    }, 2000);
                } catch (err) {
                    console.error('Failed to copy: ', err);
                    button.textContent = 'Error';
                    setTimeout(function() {
                        button.textContent = 'Copy';
                    }, 2000);
                }
                document.body.removeChild(textArea);
            }
        }
    </script>
</asp:Content>
