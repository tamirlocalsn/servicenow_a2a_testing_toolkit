---
layout: script
title: ServiceNow A2A Testing Script
---

<div class="header">
    <h1>ServiceNow A2A Testing Toolkit</h1>
    <p>Test and interact with ServiceNow A2A agents using simple bash scripts</p>
</div>

<div class="alert alert-info">
    <strong>Note:</strong> This tool is designed to help test and debug ServiceNow A2A agents. Make sure you have the necessary permissions before using it.
</div>

<div class="script-header">
    <h2>Script</h2>
    <a href="/servicenow_a2a_testing_toolkit/test_servicenow_agent.sh" download class="download-btn">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
            <polyline points="7 10 12 15 17 10"></polyline>
            <line x1="12" y1="15" x2="12" y2="3"></line>
        </svg>
        Download Script
    </a>
</div>

<div class="code-block" data-lang="bash">
    <button class="copy-btn" onclick="copyCode(this)">Copy</button>
    <pre><code>{% include test_servicenow_agent.sh %}</code></pre>
</div>

<h2 id="usage">Usage</h2>
<p>This script helps you test a ServiceNow A2A agent by performing the following actions:</p>
<ol>
    <li>Discovers the agent using the well-known endpoint</li>
    <li>Sends a test message to the agent</li>
    <li>Displays the agent's response</li>
</ol>

<h3>Prerequisites</h3>
<ul>
    <li>Bash shell</li>
    <li>curl</li>
    <li>Python 3 (for JSON parsing)</li>
    <li>uuidgen (usually available on Linux/macOS)</li>
</ul>

<h3>Configuration</h3>
<p>You can configure the script using environment variables, a <code>.env</code> file, or command-line arguments.</p>

<div class="usage-card">
    <h4>Environment Variables</h4>
    <pre>SERVICENOW_INSTANCE=your-instance.service-now.com
SERVICENOW_AGENT_ID=your-agent-id
SERVICENOW_TOKEN=your-api-token</pre>
</div>

<div class="usage-card">
    <h4>.env File</h4>
    <pre>SERVICENOW_INSTANCE=your-instance.service-now.com
SERVICENOW_AGENT_ID=your-agent-id
SERVICENOW_TOKEN=your-api-token</pre>
</div>

<h2 id="examples">Examples</h2>
<div class="usage-card">
    <h3>Basic Usage</h3>
    <pre>./test_servicenow_agent.sh -i your-instance.service-now.com -a your-agent-id -t your-api-token</pre>
</div>

<div class="usage-card">
    <h3>Custom Message</h3>
    <pre>./test_servicenow_agent.sh -i your-instance.service-now.com -a your-agent-id -t your-api-token -m "Hello, how can you help me today?"</pre>
</div>

<div class="usage-card">
    <h3>Discovery Only</h3>
    <pre>./test_servicenow_agent.sh --discovery-only</pre>
</div>

<div class="usage-card">
    <h3>Verbose Output</h3>
    <pre>./test_servicenow_agent.sh -v</pre>
</div>
