#!/bin/bash

# ServiceNow A2A Testing Guide PDF Generator
# This script converts the markdown guide to PDF format

set -e

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

print_info "ServiceNow A2A Testing Guide PDF Generator"
echo "=============================================="

# Check if pandoc is installed
if command -v pandoc &> /dev/null; then
    print_info "Found pandoc, generating PDF..."
    
    # Generate PDF with pandoc
    pandoc ServiceNow_A2A_Testing_Guide.md \
        -o ServiceNow_A2A_Testing_Guide.pdf \
        --pdf-engine=xelatex \
        --toc \
        --toc-depth=3 \
        --number-sections \
        --highlight-style=github \
        --geometry=margin=1in \
        --variable=fontsize:11pt \
        --variable=documentclass:article \
        --variable=classoption:twoside \
        --metadata title="ServiceNow A2A Testing Guide" \
        --metadata author="ServiceNow A2A Testing Tools" \
        --metadata date="$(date '+%B %Y')" \
        2>/dev/null || {
        
        print_warning "PDF generation with XeLaTeX failed, trying with default engine..."
        
        pandoc ServiceNow_A2A_Testing_Guide.md \
            -o ServiceNow_A2A_Testing_Guide.pdf \
            --toc \
            --toc-depth=3 \
            --number-sections \
            --highlight-style=github \
            --geometry=margin=1in \
            --variable=fontsize:11pt \
            --metadata title="ServiceNow A2A Testing Guide" \
            --metadata author="ServiceNow A2A Testing Tools" \
            --metadata date="$(date '+%B %Y')" \
            2>/dev/null || {
            
            print_error "PDF generation failed. Please install a LaTeX distribution."
            echo "On macOS: brew install --cask mactex"
            echo "On Ubuntu: sudo apt-get install texlive-latex-recommended"
            exit 1
        }
    }
    
    if [ -f "ServiceNow_A2A_Testing_Guide.pdf" ]; then
        print_success "PDF generated successfully: ServiceNow_A2A_Testing_Guide.pdf"
        
        # Get file size
        if command -v ls &> /dev/null; then
            FILE_SIZE=$(ls -lh ServiceNow_A2A_Testing_Guide.pdf | awk '{print $5}')
            echo "File size: $FILE_SIZE"
        fi
        
        # Try to open the PDF
        if command -v open &> /dev/null; then
            print_info "Opening PDF..."
            open ServiceNow_A2A_Testing_Guide.pdf
        elif command -v xdg-open &> /dev/null; then
            print_info "Opening PDF..."
            xdg-open ServiceNow_A2A_Testing_Guide.pdf
        fi
    else
        print_error "PDF file was not created"
        exit 1
    fi
    
else
    print_warning "pandoc not found. Please install pandoc to generate PDF."
    echo ""
    echo "Installation instructions:"
    echo "  macOS:   brew install pandoc"
    echo "  Ubuntu:  sudo apt-get install pandoc"
    echo "  Windows: Download from https://pandoc.org/installing.html"
    echo ""
    echo "Alternative methods to create PDF:"
    echo ""
    echo "1. Online Markdown to PDF converters:"
    echo "   - https://www.markdowntopdf.com/"
    echo "   - https://md2pdf.netlify.app/"
    echo ""
    echo "2. Use a Markdown editor with PDF export:"
    echo "   - Typora"
    echo "   - Mark Text"
    echo "   - Visual Studio Code with Markdown PDF extension"
    echo ""
    echo "3. Print to PDF from browser:"
    echo "   - Open ServiceNow_A2A_Testing_Guide.md in a Markdown viewer"
    echo "   - Use browser's Print > Save as PDF function"
    echo ""
    print_info "The markdown file is ready: ServiceNow_A2A_Testing_Guide.md"
fi

echo ""
print_info "Additional files included in the package:"
echo "  - generic_a2a_client.py         (Python A2A client)"
echo "  - test_servicenow_agent.sh      (Automated testing script)"
echo "  - generate_curl_commands.sh     (Curl command generator)"
echo "  - examples.py                   (Python usage examples)"
echo "  - .env.template                 (Configuration template)"
echo "  - README.md                     (Quick reference)"
echo ""
print_success "ServiceNow A2A Testing Package is ready!"
