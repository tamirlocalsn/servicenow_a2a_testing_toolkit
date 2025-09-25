#!/bin/bash

# Create HTML versions of markdown files for easy PDF conversion
set -e

PACKAGE_DIR="ServiceNow_A2A_Testing_Package_20250924"

echo "🔄 Creating HTML versions of documentation..."

if [ ! -d "$PACKAGE_DIR" ]; then
    echo "❌ Package directory not found: $PACKAGE_DIR"
    exit 1
fi

cd "$PACKAGE_DIR"

# Create a CSS file for styling
cat > style.css << 'EOF'
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    max-width: 900px;
    margin: 0 auto;
    padding: 40px 20px;
    line-height: 1.6;
    color: #333;
}

h1, h2, h3, h4 {
    color: #2c3e50;
    margin-top: 2em;
    margin-bottom: 1em;
}

h1 {
    border-bottom: 3px solid #3498db;
    padding-bottom: 10px;
}

h2 {
    border-bottom: 1px solid #bdc3c7;
    padding-bottom: 8px;
}

code {
    background: #f8f9fa;
    padding: 2px 6px;
    border-radius: 4px;
    font-family: 'SF Mono', Monaco, monospace;
    font-size: 0.9em;
}

pre {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    overflow-x: auto;
    border-left: 4px solid #3498db;
}

pre code {
    background: none;
    padding: 0;
}

table {
    border-collapse: collapse;
    width: 100%;
    margin: 20px 0;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

th, td {
    border: 1px solid #ddd;
    padding: 12px 16px;
    text-align: left;
}

th {
    background-color: #3498db;
    color: white;
    font-weight: 600;
}

tr:nth-child(even) {
    background-color: #f8f9fa;
}

.toc {
    background: #ecf0f1;
    padding: 20px;
    border-radius: 8px;
    margin: 30px 0;
}

a {
    color: #3498db;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

@media print {
    body {
        margin: 0;
        padding: 20px;
    }
    .toc {
        break-after: page;
    }
}
EOF

# Convert each markdown file to HTML
for md_file in *.md; do
    if [ -f "$md_file" ]; then
        echo "📄 Converting $md_file..."
        
        base_name="${md_file%.md}"
        html_file="${base_name}.html"
        
        # Convert to HTML
        pandoc "$md_file" \
            -o "$html_file" \
            --standalone \
            --toc \
            --toc-depth=3 \
            --number-sections \
            --css=style.css \
            --metadata title="ServiceNow A2A Testing - ${base_name}" \
            --metadata author="ServiceNow A2A Testing Tools" \
            --metadata date="$(date '+%B %Y')"
        
        if [ -f "$html_file" ]; then
            echo "✅ Created $html_file"
        else
            echo "❌ Failed to create $html_file"
        fi
    fi
done

cd ..

# Create new package with HTML files
NEW_PACKAGE_DIR="${PACKAGE_DIR}_with_HTML"
if [ -d "$NEW_PACKAGE_DIR" ]; then
    rm -rf "$NEW_PACKAGE_DIR"
fi

cp -r "$PACKAGE_DIR" "$NEW_PACKAGE_DIR"

echo ""
echo "📦 Created new package: $NEW_PACKAGE_DIR"

# Create zip
zip -r "${NEW_PACKAGE_DIR}.zip" "$NEW_PACKAGE_DIR/" > /dev/null

echo "📦 Created zip: ${NEW_PACKAGE_DIR}.zip"

# Get package size
PACKAGE_SIZE=$(du -sh "$NEW_PACKAGE_DIR" | cut -f1)
ZIP_SIZE=$(du -sh "${NEW_PACKAGE_DIR}.zip" | cut -f1)
echo "Package size: $PACKAGE_SIZE (zip: $ZIP_SIZE)"

echo ""
echo "✅ HTML package created successfully!"
echo ""
echo "📋 Contents:"
ls -la "$NEW_PACKAGE_DIR/"

echo ""
echo "🌐 HTML documentation files:"
ls -la "$NEW_PACKAGE_DIR/"*.html 2>/dev/null

echo ""
echo "💡 To create PDFs:"
echo "   1. Open any .html file in your browser"
echo "   2. Use File > Print > Save as PDF"
echo "   3. The files are optimized for PDF printing"
