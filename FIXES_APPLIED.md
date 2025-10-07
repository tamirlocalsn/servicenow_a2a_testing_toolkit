# ServiceNow A2A Test Script Fixes

## Date: 2025-10-07

## Issues Identified and Fixed

### 1. **URL Construction Problem**
**Issue**: The script was expecting `SERVICENOW_INSTANCE` to be just the domain (e.g., `productxbu.service-now.com`) but users were providing the full URL with protocol and trailing slash (e.g., `https://productxbu.service-now.com/`).

**Fix**: Added URL cleanup logic to strip protocols and trailing slashes:
```bash
# Clean up the instance URL (remove protocol and trailing slashes)
CLEAN_INSTANCE=$(echo "$SERVICENOW_INSTANCE" | sed -e 's|^https\?://||' -e 's|/$||')
```

### 2. **Curl Timeout Missing**
**Issue**: The curl commands had no timeout, causing the script to hang indefinitely if the API endpoint didn't respond.

**Fix**: Added 30-second timeout to all curl commands:
```bash
curl -s -w "\n%{http_code}" \
    --max-time 30 \
    -H "Content-Type: application/json" \
    ...
```

### 3. **Error Output Not Captured**
**Issue**: Curl errors were not being captured, making debugging difficult.

**Fix**: Added `2>&1` to capture stderr output:
```bash
"$DISCOVERY_URL" 2>&1)
```

## Files Updated

1. ✅ `test_servicenow_agent.sh` - Main test script
2. ✅ `ServiceNow_A2A_Bash_Scripts.html` - HTML documentation with embedded scripts

## Test Results

### Before Fix:
- Script hung at "Step 1: Testing agent discovery..."
- No timeout, requiring manual interruption

### After Fix:
```
[INFO] Step 1: Testing agent discovery...
[SUCCESS] Agent discovery successful!
  Agent Name: Servicenow Expert Agent
  Description: Servicenow Platform Expert AI Agent
```

## Usage Recommendations

### Option 1: Use the corrected script directly
```bash
cd /Users/tamir.livneh/git/a2a_experiments/servicenow_a2a_testing_toolkit
./test_servicenow_agent.sh
```

### Option 2: Copy to your test location
```bash
cp test_servicenow_agent.sh /path/to/your/test/folder/
```

### Option 3: Copy from the updated HTML page
The `ServiceNow_A2A_Bash_Scripts.html` file now contains the corrected script code.

## .env File Configuration

Your `.env` file can now accept either format:

**Option 1** (recommended):
```bash
SERVICENOW_INSTANCE=productxbu.service-now.com
```

**Option 2** (also works now):
```bash
SERVICENOW_INSTANCE=https://productxbu.service-now.com/
```

The script will automatically clean up the URL format.

## Important Notes

⚠️ **Do not copy scripts from HTML pages in browsers** - This can corrupt special characters and line endings, causing syntax errors.

✅ **Instead**:
- Copy the `.sh` file directly in your file system
- Or use `curl` to download from a repository
- Or use the provided HTML file and copy from the `<pre>` blocks carefully

## Verification

To verify the script is working correctly:

```bash
# Run with verbose output
./test_servicenow_agent.sh -v

# Test discovery only
./test_servicenow_agent.sh --discovery-only

# Custom message
./test_servicenow_agent.sh -m "What ServiceNow tables can you help me with?"
```

## Next Steps

The script is now fully functional and should:
1. ✅ Accept URLs with or without protocols
2. ✅ Timeout after 30 seconds if no response
3. ✅ Show clear error messages
4. ✅ Successfully discover and test agents

Run the test again from the main repository directory or copy the corrected script to your test location.
