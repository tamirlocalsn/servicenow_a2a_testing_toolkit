#!/bin/bash

# Create PDF files from HTML using headless browser approach
set -e

PACKAGE_DIR="ServiceNow_A2A_Testing_Package_20250924_with_HTML"

echo "📄 Converting HTML files to PDF..."

if [ ! -d "$PACKAGE_DIR" ]; then
    echo "❌ Package directory not found: $PACKAGE_DIR"
    exit 1
fi

cd "$PACKAGE_DIR"

# Function to convert HTML to PDF using different methods
convert_html_to_pdf() {
    local html_file="$1"
    local pdf_file="${html_file%.html}.pdf"
    
    echo "🔄 Converting $html_file to $pdf_file..."
    
    # Method 1: Try with pandoc (if LaTeX is available)
    if pandoc "$html_file" -o "$pdf_file" 2>/dev/null; then
        echo "✅ Created $pdf_file using pandoc"
        return 0
    fi
    
    # Method 2: Try with wkhtmltopdf (if available)
    if command -v wkhtmltopdf &> /dev/null; then
        wkhtmltopdf --page-size A4 --margin-top 20mm --margin-bottom 20mm --margin-left 15mm --margin-right 15mm "$html_file" "$pdf_file" 2>/dev/null
        if [ -f "$pdf_file" ]; then
            echo "✅ Created $pdf_file using wkhtmltopdf"
            return 0
        fi
    fi
    
    # Method 3: Try with Chrome/Chromium headless (if available)
    for browser in google-chrome chromium-browser chrome; do
        if command -v $browser &> /dev/null; then
            $browser --headless --disable-gpu --print-to-pdf="$pdf_file" --no-margins "file://$(pwd)/$html_file" 2>/dev/null
            if [ -f "$pdf_file" ]; then
                echo "✅ Created $pdf_file using $browser"
                return 0
            fi
        fi
    done
    
    echo "⚠️  Could not convert $html_file to PDF automatically"
    echo "   Please convert manually using browser Print > Save as PDF"
    return 1
}

# Convert each HTML file
success_count=0
total_count=0

for html_file in *.html; do
    if [ -f "$html_file" ]; then
        total_count=$((total_count + 1))
        if convert_html_to_pdf "$html_file"; then
            success_count=$((success_count + 1))
        fi
    fi
done

echo ""
echo "📊 Conversion Summary:"
echo "   Total HTML files: $total_count"
echo "   Successfully converted: $success_count"
echo "   Manual conversion needed: $((total_count - success_count))"

if [ $success_count -gt 0 ]; then
    echo ""
    echo "📄 PDF files created:"
    ls -la *.pdf 2>/dev/null
fi

cd ..

# Create final package with PDFs
FINAL_PACKAGE_DIR="ServiceNow_A2A_Testing_Package_20250924_FINAL"
if [ -d "$FINAL_PACKAGE_DIR" ]; then
    rm -rf "$FINAL_PACKAGE_DIR"
fi

cp -r "$PACKAGE_DIR" "$FINAL_PACKAGE_DIR"

echo ""
echo "📦 Created final package: $FINAL_PACKAGE_DIR"

# Create final zip
zip -r "${FINAL_PACKAGE_DIR}.zip" "$FINAL_PACKAGE_DIR/" > /dev/null

echo "📦 Created final zip: ${FINAL_PACKAGE_DIR}.zip"

# Get package size
PACKAGE_SIZE=$(du -sh "$FINAL_PACKAGE_DIR" | cut -f1)
ZIP_SIZE=$(du -sh "${FINAL_PACKAGE_DIR}.zip" | cut -f1)
echo "Final package size: $PACKAGE_SIZE (zip: $ZIP_SIZE)"

echo ""
echo "✅ Final ServiceNow A2A Testing Package ready!"
echo ""
echo "📋 Package includes:"
echo "   ✅ All testing tools (Python, bash, curl)"
echo "   ✅ Complete documentation in Markdown"
echo "   ✅ Professional HTML versions"
if [ $success_count -gt 0 ]; then
    echo "   ✅ PDF documentation files"
else
    echo "   📄 HTML files ready for manual PDF conversion"
fi
echo ""
echo "🚀 Ready for distribution to ServiceNow customers!"
