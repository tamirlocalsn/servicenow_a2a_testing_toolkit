# PDF Conversion Instructions

This package includes professional HTML versions of all documentation that can be easily converted to PDF format.

## 📄 HTML Files Available for PDF Conversion

1. **ServiceNow_A2A_Testing_Guide.html** - Complete testing guide (117KB)
2. **README.html** - Quick reference guide (25KB)  
3. **PACKAGE_README.html** - Package getting started guide (14KB)

## 🖨️ How to Convert HTML to PDF

### Method 1: Browser Print-to-PDF (Recommended)

**For any web browser (Chrome, Safari, Firefox, Edge):**

1. **Open the HTML file:**
   - Double-click any `.html` file to open in your default browser
   - Or right-click → "Open with" → choose your browser

2. **Print to PDF:**
   - Press `Cmd+P` (Mac) or `Ctrl+P` (Windows/Linux)
   - In the print dialog, select **"Save as PDF"** as destination
   - Choose location and filename
   - Click **"Save"**

3. **Recommended PDF names:**
   - `ServiceNow_A2A_Testing_Guide.html` → `ServiceNow_A2A_Testing_Guide.pdf`
   - `README.html` → `ServiceNow_A2A_Quick_Reference.pdf`
   - `PACKAGE_README.html` → `ServiceNow_A2A_Getting_Started.pdf`

### Method 2: Online HTML to PDF Converters

**Upload HTML files to:**
- https://www.html-to-pdf.net/
- https://pdfcrowd.com/html-to-pdf-api/
- https://www.sejda.com/html-to-pdf

### Method 3: Command Line Tools

**Install and use wkhtmltopdf:**
```bash
# Install (varies by system)
brew install wkhtmltopdf          # macOS
sudo apt-get install wkhtmltopdf  # Ubuntu
choco install wkhtmltopdf         # Windows

# Convert
wkhtmltopdf --page-size A4 --margin-top 20mm ServiceNow_A2A_Testing_Guide.html ServiceNow_A2A_Testing_Guide.pdf
```

**Or use weasyprint:**
```bash
pip install weasyprint
weasyprint ServiceNow_A2A_Testing_Guide.html ServiceNow_A2A_Testing_Guide.pdf
```

## ✨ HTML Features Optimized for PDF

The HTML files include:

- **Professional typography** - Clean, readable fonts
- **Table of contents** - Clickable navigation
- **Proper page breaks** - Sections start on new pages
- **Print-friendly styling** - Optimized margins and spacing
- **Syntax highlighting** - Code blocks with proper formatting
- **Responsive tables** - Professional table styling

## 📋 Recommended PDF Structure

After conversion, you'll have a complete documentation set:

1. **ServiceNow_A2A_Testing_Guide.pdf** (Main documentation)
   - Complete setup instructions
   - All testing methods
   - Troubleshooting guide
   - API reference

2. **ServiceNow_A2A_Quick_Reference.pdf** (Quick start)
   - Installation steps
   - Configuration guide
   - Basic usage examples

3. **ServiceNow_A2A_Getting_Started.pdf** (Package overview)
   - Package contents
   - Quick setup
   - Usage tips

## 🎯 Tips for Best PDF Quality

1. **Use Chrome or Safari** for best rendering
2. **Select "More settings"** in print dialog
3. **Choose "A4" or "Letter"** paper size
4. **Set margins to "Default"** or "Minimum"
5. **Enable "Background graphics"** for styling
6. **Use "Print headers and footers"** for page numbers

## 📦 Final Package Contents

After PDF conversion, your complete package will include:

```
ServiceNow_A2A_Testing_Package/
├── 📄 PDF Documentation
│   ├── ServiceNow_A2A_Testing_Guide.pdf
│   ├── ServiceNow_A2A_Quick_Reference.pdf
│   └── ServiceNow_A2A_Getting_Started.pdf
├── 🛠️ Testing Tools
│   ├── generic_a2a_client.py
│   ├── test_servicenow_agent.sh
│   ├── generate_curl_commands.sh
│   └── examples.py
├── ⚙️ Configuration
│   ├── .env.template
│   ├── requirements.txt
│   └── quick_start.sh
└── 📚 Source Documentation
    ├── *.md (Markdown sources)
    ├── *.html (HTML versions)
    └── style.css (Styling)
```

## 🚀 Ready for Distribution

Once you've converted the HTML files to PDF, you'll have a complete, professional ServiceNow A2A testing package ready for distribution to customers!
