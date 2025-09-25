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
