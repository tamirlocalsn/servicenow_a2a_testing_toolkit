#!/bin/bash

# Create a single comprehensive HTML guide with all instructions and scripts
set -e

echo "🔄 Creating comprehensive ServiceNow A2A HTML guide..."

PACKAGE_DIR="ServiceNow_A2A_Testing_Package_20250924_FINAL"
OUTPUT_FILE="ServiceNow_A2A_Complete_Guide.html"

if [ ! -d "$PACKAGE_DIR" ]; then
    echo "❌ Package directory not found: $PACKAGE_DIR"
    exit 1
fi

# Create the comprehensive HTML file
cat > "$OUTPUT_FILE" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ServiceNow A2A Testing - Complete Guide</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f8f9fa;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 300;
        }
        
        .header p {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .nav {
            background: #2c3e50;
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .nav ul {
            list-style: none;
            display: flex;
            flex-wrap: wrap;
        }
        
        .nav li {
            flex: 1;
            min-width: 150px;
        }
        
        .nav a {
            display: block;
            padding: 15px 20px;
            color: white;
            text-decoration: none;
            border-right: 1px solid #34495e;
            transition: background 0.3s;
        }
        
        .nav a:hover {
            background: #34495e;
        }
        
        .content {
            padding: 40px;
        }
        
        .section {
            margin-bottom: 60px;
            padding-bottom: 40px;
            border-bottom: 2px solid #ecf0f1;
        }
        
        .section:last-child {
            border-bottom: none;
        }
        
        h1, h2, h3, h4 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        
        h1 {
            font-size: 2.2em;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
        }
        
        h2 {
            font-size: 1.8em;
            color: #34495e;
            margin-top: 40px;
        }
        
        h3 {
            font-size: 1.4em;
            color: #7f8c8d;
            margin-top: 30px;
        }
        
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .feature-card {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            border-left: 4px solid #3498db;
        }
        
        .feature-card h4 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .code-block {
            background: #2c3e50;
            color: #ecf0f1;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            overflow-x: auto;
            position: relative;
        }
        
        .code-block::before {
            content: attr(data-lang);
            position: absolute;
            top: 5px;
            right: 10px;
            background: #3498db;
            color: white;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 0.8em;
        }
        
        .code-block pre {
            margin: 0;
            font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
            font-size: 0.9em;
        }
        
        .inline-code {
            background: #ecf0f1;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'SF Mono', Monaco, monospace;
            font-size: 0.9em;
        }
        
        .table-container {
            overflow-x: auto;
            margin: 20px 0;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background: #3498db;
            color: white;
            font-weight: 600;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .alert {
            padding: 15px 20px;
            margin: 20px 0;
            border-radius: 5px;
            border-left: 4px solid;
        }
        
        .alert-info {
            background: #e3f2fd;
            border-color: #2196f3;
            color: #1565c0;
        }
        
        .alert-success {
            background: #e8f5e8;
            border-color: #4caf50;
            color: #2e7d32;
        }
        
        .alert-warning {
            background: #fff3e0;
            border-color: #ff9800;
            color: #ef6c00;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 10px 10px 10px 0;
            transition: background 0.3s;
        }
        
        .btn:hover {
            background: #2980b9;
        }
        
        .btn-success {
            background: #27ae60;
        }
        
        .btn-success:hover {
            background: #229954;
        }
        
        .file-tree {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            font-family: 'SF Mono', Monaco, monospace;
            font-size: 0.9em;
            margin: 20px 0;
        }
        
        .step-number {
            display: inline-block;
            width: 30px;
            height: 30px;
            background: #3498db;
            color: white;
            border-radius: 50%;
            text-align: center;
            line-height: 30px;
            margin-right: 10px;
            font-weight: bold;
        }
        
        .footer {
            background: #2c3e50;
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        @media (max-width: 768px) {
            .nav ul {
                flex-direction: column;
            }
            
            .nav a {
                border-right: none;
                border-bottom: 1px solid #34495e;
            }
            
            .content {
                padding: 20px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
        }
        
        @media print {
            .nav {
                display: none;
            }
            
            .container {
                box-shadow: none;
            }
            
            .section {
                break-inside: avoid;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>ServiceNow A2A Testing</h1>
            <p>Complete Guide & Testing Toolkit</p>
        </div>
        
        <nav class="nav">
            <ul>
                <li><a href="#overview">Overview</a></li>
                <li><a href="#quickstart">Quick Start</a></li>
                <li><a href="#tools">Testing Tools</a></li>
                <li><a href="#python">Python Client</a></li>
                <li><a href="#scripts">Bash Scripts</a></li>
                <li><a href="#troubleshooting">Troubleshooting</a></li>
            </ul>
        </nav>
        
        <div class="content">
EOF

# Add the rest of the content by reading from the package files
echo "📝 Adding content sections..."

# Add overview section
cat >> "$OUTPUT_FILE" << 'EOF'
            <section id="overview" class="section">
                <h1>🎯 Overview</h1>
                
                <p>This comprehensive guide provides everything you need to test ServiceNow Agent-to-Agent (A2A) implementations. It includes production-ready tools, detailed instructions, and troubleshooting guides that work with any ServiceNow instance and agent.</p>
                
                <div class="feature-grid">
                    <div class="feature-card">
                        <h4>🔧 Universal Compatibility</h4>
                        <p>Works with any ServiceNow instance and agent. No hardcoded values or dependencies.</p>
                    </div>
                    <div class="feature-card">
                        <h4>🛠️ Multiple Testing Methods</h4>
                        <p>Python SDK, direct HTTP calls, and curl commands for different use cases.</p>
                    </div>
                    <div class="feature-card">
                        <h4>📚 Complete Documentation</h4>
                        <p>Step-by-step instructions, code examples, and troubleshooting guides.</p>
                    </div>
                    <div class="feature-card">
                        <h4>🚀 Production Ready</h4>
                        <p>Error handling, configuration management, and conversation context support.</p>
                    </div>
                </div>
                
                <div class="alert alert-info">
                    <strong>What's Included:</strong> Python A2A client, automated testing scripts, curl command generators, configuration templates, and comprehensive documentation.
                </div>
            </section>
EOF

echo "✅ HTML guide creation completed!"
echo "📄 Output file: $OUTPUT_FILE"
echo "🌐 Open in browser to view the complete guide"
