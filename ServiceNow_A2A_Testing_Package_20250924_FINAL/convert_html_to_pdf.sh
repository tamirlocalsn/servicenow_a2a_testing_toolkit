#!/bin/bash

# Convert HTML files to PDF using system browser
# This script provides instructions and automation for PDF conversion

echo "📄 ServiceNow A2A Testing - HTML to PDF Converter"
echo "=================================================="
echo ""

# Check for HTML files
html_files=(*.html)
if [ ! -f "${html_files[0]}" ]; then
    echo "❌ No HTML files found in current directory"
    exit 1
fi

echo "🌐 Found HTML files:"
for html_file in *.html; do
    if [ -f "$html_file" ]; then
        echo "   - $html_file"
    fi
done

echo ""
echo "💡 To convert HTML files to PDF, you have several options:"
echo ""

echo "📋 Option 1: Manual Browser Conversion (Recommended)"
echo "   1. Open any .html file in your web browser"
echo "   2. Press Cmd+P (Mac) or Ctrl+P (Windows/Linux)"
echo "   3. Select 'Save as PDF' as destination"
echo "   4. Click 'Save' and choose location"
echo ""

echo "📋 Option 2: Automated Browser Conversion (macOS)"
if command -v osascript &> /dev/null; then
    echo "   Available - run this script with --auto flag"
    
    if [ "$1" = "--auto" ]; then
        echo ""
        echo "🤖 Starting automated conversion..."
        
        for html_file in *.html; do
            if [ -f "$html_file" ]; then
                pdf_file="${html_file%.html}.pdf"
                echo "   Converting $html_file to $pdf_file..."
                
                # Open in browser and trigger print dialog
                osascript << EOF
tell application "Safari"
    activate
    open POSIX file "$(pwd)/$html_file"
    delay 2
    tell application "System Events"
        keystroke "p" using command down
        delay 1
        keystroke return
        delay 1
    end tell
end tell
EOF
                echo "   ✅ Print dialog opened for $html_file"
                echo "      Please select 'Save as PDF' and save as $pdf_file"
                echo "      Press Enter when done..."
                read -r
            fi
        done
        
        echo "✅ Automated conversion process completed!"
    fi
else
    echo "   Not available (requires macOS)"
fi

echo ""
echo "📋 Option 3: Command Line Tools"
echo "   Install wkhtmltopdf or weasyprint:"
echo "   - pip install weasyprint"
echo "   - Then run: weasyprint file.html file.pdf"
echo ""

echo "📋 Option 4: Online Converters"
echo "   Upload HTML files to:"
echo "   - https://www.html-to-pdf.net/"
echo "   - https://pdfcrowd.com/html-to-pdf-api/"
echo ""

echo "✨ The HTML files are optimized for PDF printing with:"
echo "   - Professional styling and typography"
echo "   - Table of contents with page breaks"
echo "   - Proper margins and spacing"
echo "   - Print-friendly colors and fonts"
echo ""

echo "📦 Recommended PDF names:"
for html_file in *.html; do
    if [ -f "$html_file" ]; then
        pdf_name="${html_file%.html}.pdf"
        echo "   $html_file → $pdf_name"
    fi
done
