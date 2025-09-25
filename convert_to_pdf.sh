#!/bin/bash

# Convert ServiceNow A2A Testing Package Markdown files to PDF
# Creates professional-looking PDFs with proper formatting

set -e

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[NOTE]${NC} $1"; }

PACKAGE_DIR="ServiceNow_A2A_Testing_Package_20250924"

print_info "Converting ServiceNow A2A Testing Package Markdown to PDF"
echo "=========================================================="

# Check if package directory exists
if [ ! -d "$PACKAGE_DIR" ]; then
    echo "❌ Package directory not found: $PACKAGE_DIR"
    exit 1
fi

cd "$PACKAGE_DIR"

# Function to convert markdown to PDF with nice formatting
convert_md_to_pdf() {
    local md_file="$1"
    local pdf_file="${md_file%.md}.pdf"
    local title="$2"
    
    print_info "Converting $md_file to $pdf_file..."
    
    # Try multiple approaches for PDF generation
    
    # Approach 1: Try with basic pandoc (no LaTeX)
    pandoc "$md_file" \
        -o "$pdf_file" \
        --toc \
        --toc-depth=3 \
        --number-sections \
        --highlight-style=github \
        --metadata title="$title" \
        --metadata author="ServiceNow A2A Testing Tools" \
        --metadata date="$(date '+%B %Y')" \
        2>/dev/null || {
        
        print_warning "Basic PDF generation failed for $md_file, trying HTML intermediate..."
        
        # Approach 2: Convert to HTML first, then to PDF via browser print
        local html_file="${md_file%.md}.html"
        
        pandoc "$md_file" \
            -o "$html_file" \
            --standalone \
            --toc \
            --toc-depth=3 \
            --number-sections \
            --highlight-style=github \
            --css=<(echo "
                body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; line-height: 1.6; }
                h1, h2, h3 { color: #2c3e50; border-bottom: 1px solid #eee; padding-bottom: 10px; }
                code { background: #f8f9fa; padding: 2px 4px; border-radius: 3px; font-family: 'SF Mono', Monaco, monospace; }
                pre { background: #f8f9fa; padding: 15px; border-radius: 5px; overflow-x: auto; }
                blockquote { border-left: 4px solid #3498db; margin: 0; padding-left: 20px; color: #666; }
                table { border-collapse: collapse; width: 100%; margin: 20px 0; }
                th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
                th { background-color: #f8f9fa; font-weight: 600; }
                .toc { background: #f8f9fa; padding: 20px; border-radius: 5px; margin: 20px 0; }
            ") \
            --metadata title="$title" \
            --metadata author="ServiceNow A2A Testing Tools" \
            --metadata date="$(date '+%B %Y')" \
            2>/dev/null || {
            
            print_warning "HTML generation also failed for $md_file, creating simple HTML version..."
            
            # Approach 3: Very basic HTML conversion
            pandoc "$md_file" \
                -o "$html_file" \
                --standalone \
                --metadata title="$title" \
                2>/dev/null || {
                
                echo "❌ All conversion methods failed for $md_file"
                return 1
            }
        }
        
        if [ -f "$html_file" ]; then
            print_success "Created HTML version: $html_file"
            print_warning "PDF generation requires LaTeX. HTML version created instead."
            print_warning "To convert HTML to PDF, open $html_file in browser and use Print > Save as PDF"
            
            # Get file size
            if command -v ls &> /dev/null; then
                FILE_SIZE=$(ls -lh "$html_file" | awk '{print $5}')
                echo "   File size: $FILE_SIZE"
            fi
            
            return 0
        else
            echo "❌ HTML file was not created: $html_file"
            return 1
        fi
    }
    
    if [ -f "$pdf_file" ]; then
        print_success "Created $pdf_file"
        
        # Get file size
        if command -v ls &> /dev/null; then
            FILE_SIZE=$(ls -lh "$pdf_file" | awk '{print $5}')
            echo "   File size: $FILE_SIZE"
        fi
    else
        echo "❌ PDF file was not created: $pdf_file"
        return 1
    fi
}

# Convert main documentation files
print_info "Converting main documentation files..."

# 1. Convert the comprehensive testing guide
if [ -f "ServiceNow_A2A_Testing_Guide.md" ]; then
    convert_md_to_pdf "ServiceNow_A2A_Testing_Guide.md" "ServiceNow A2A Testing Guide"
fi

# 2. Convert the README
if [ -f "README.md" ]; then
    convert_md_to_pdf "README.md" "ServiceNow A2A Client - Quick Reference"
fi

# 3. Convert the package README
if [ -f "PACKAGE_README.md" ]; then
    convert_md_to_pdf "PACKAGE_README.md" "ServiceNow A2A Testing Package - Getting Started"
fi

echo ""
print_info "PDF conversion summary:"
ls -la *.pdf 2>/dev/null || echo "No PDF files found"

echo ""
print_success "PDF conversion completed!"

# Go back to parent directory
cd ..

print_info "Updating package with PDF files..."

# Create new package with PDFs
NEW_PACKAGE_DIR="${PACKAGE_DIR}_with_PDFs"
if [ -d "$NEW_PACKAGE_DIR" ]; then
    rm -rf "$NEW_PACKAGE_DIR"
fi

cp -r "$PACKAGE_DIR" "$NEW_PACKAGE_DIR"

print_success "Created new package: $NEW_PACKAGE_DIR"

# Create new zip with PDFs
print_info "Creating zip archive with PDFs..."
zip -r "${NEW_PACKAGE_DIR}.zip" "$NEW_PACKAGE_DIR/" > /dev/null

if [ -f "${NEW_PACKAGE_DIR}.zip" ]; then
    print_success "Zip archive created: ${NEW_PACKAGE_DIR}.zip"
    
    # Get package sizes
    if command -v du &> /dev/null; then
        PACKAGE_SIZE=$(du -sh "$NEW_PACKAGE_DIR" | cut -f1)
        ZIP_SIZE=$(du -sh "${NEW_PACKAGE_DIR}.zip" | cut -f1)
        echo "Package size: $PACKAGE_SIZE (zip: $ZIP_SIZE)"
    fi
else
    echo "❌ Failed to create zip archive"
    exit 1
fi

echo ""
print_success "ServiceNow A2A Testing Package with PDFs is ready!"
echo ""
print_info "Package contents:"
ls -la "$NEW_PACKAGE_DIR/"

echo ""
print_info "PDF files included:"
ls -la "$NEW_PACKAGE_DIR/"*.pdf 2>/dev/null || echo "No PDF files found in package"
