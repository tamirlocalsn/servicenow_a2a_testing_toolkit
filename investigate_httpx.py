#!/usr/bin/env python3

import asyncio
import httpx
import requests
import json
from uuid import uuid4
from pathlib import Path
import os

# Load environment variables
env_file = Path(__file__).parent / '.env'
if env_file.exists():
    with open(env_file) as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                key, value = line.strip().split('=', 1)
                os.environ[key] = value

API_KEY = os.getenv("SERVICENOW_TOKEN")
URL = "https://acnaccdemo.service-now.com/api/sn_aia/a2a/v1/agent/id/138d4b97878f66100b12a75d3fbb35f8"

# Create test payload
request_id = uuid4().hex
message_id = uuid4().hex

payload = {
    "jsonrpc": "2.0",
    "method": "message/send",
    "params": {
        "message": {
            "role": "user",
            "parts": [{"kind": "text", "text": "Test message"}],
            "messageId": message_id,
            "kind": "user"
        },
        "context": {"contextId": None, "taskId": None},
        "metadata": {},
        "pushNotificationUrl": f"http://localhost:8080/a2a/callback/test/{request_id}",
        "id": request_id
    },
    "id": request_id
}


def test_with_requests():
    """Test with requests library"""
    print("🔍 TESTING WITH REQUESTS:")
    print("=" * 50)
    
    headers = {
        'content-type': 'application/json',
        'x-sn-apikey': API_KEY,
        'user-agent': 'curl/8.7.1'
    }
    
    print("Headers being sent:")
    for k, v in headers.items():
        print(f"  {k}: {v}")
    
    print(f"\nPayload size: {len(json.dumps(payload))} bytes")
    
    try:
        response = requests.post(URL, json=payload, headers=headers, timeout=30)
        
        print(f"\nResponse Status: {response.status_code}")
        print("Response Headers:")
        for k, v in response.headers.items():
            print(f"  {k}: {v}")
        
        if response.status_code == 200:
            print("✅ SUCCESS with requests!")
            return True
        else:
            print(f"❌ FAILED with requests: {response.status_code}")
            print(f"Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ EXCEPTION with requests: {e}")
        return False


async def test_with_httpx_minimal():
    """Test with httpx using minimal configuration"""
    print("\n🔍 TESTING WITH HTTPX (MINIMAL):")
    print("=" * 50)
    
    # Try with minimal headers - exactly like requests
    headers = {
        'content-type': 'application/json',
        'x-sn-apikey': API_KEY,
        'user-agent': 'curl/8.7.1'
    }
    
    print("Headers being sent:")
    for k, v in headers.items():
        print(f"  {k}: {v}")
    
    print(f"\nPayload size: {len(json.dumps(payload))} bytes")
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(URL, json=payload, headers=headers, timeout=30.0)
            
            print(f"\nResponse Status: {response.status_code}")
            print("Response Headers:")
            for k, v in response.headers.items():
                print(f"  {k}: {v}")
            
            if response.status_code == 200:
                print("✅ SUCCESS with httpx!")
                return True
            else:
                print(f"❌ FAILED with httpx: {response.status_code}")
                print(f"Response: {response.text}")
                return False
                
    except Exception as e:
        print(f"❌ EXCEPTION with httpx: {e}")
        return False


async def test_with_httpx_configured():
    """Test with httpx using client-level headers"""
    print("\n🔍 TESTING WITH HTTPX (CLIENT HEADERS):")
    print("=" * 50)
    
    headers = {
        'content-type': 'application/json',
        'x-sn-apikey': API_KEY,
        'user-agent': 'curl/8.7.1'
    }
    
    print("Headers configured at client level:")
    for k, v in headers.items():
        print(f"  {k}: {v}")
    
    print(f"\nPayload size: {len(json.dumps(payload))} bytes")
    
    try:
        async with httpx.AsyncClient(headers=headers) as client:
            response = await client.post(URL, json=payload, timeout=30.0)
            
            print(f"\nActual request headers sent:")
            # httpx doesn't expose the actual sent headers easily, but we can check client headers
            for k, v in client.headers.items():
                print(f"  {k}: {v}")
            
            print(f"\nResponse Status: {response.status_code}")
            print("Response Headers:")
            for k, v in response.headers.items():
                print(f"  {k}: {v}")
            
            if response.status_code == 200:
                print("✅ SUCCESS with httpx (client headers)!")
                return True
            else:
                print(f"❌ FAILED with httpx (client headers): {response.status_code}")
                print(f"Response: {response.text}")
                return False
                
    except Exception as e:
        print(f"❌ EXCEPTION with httpx (client headers): {e}")
        return False


async def test_with_httpx_raw():
    """Test with httpx using raw content instead of json parameter"""
    print("\n🔍 TESTING WITH HTTPX (RAW CONTENT):")
    print("=" * 50)
    
    headers = {
        'content-type': 'application/json',
        'x-sn-apikey': API_KEY,
        'user-agent': 'curl/8.7.1'
    }
    
    # Send raw JSON content instead of using json parameter
    json_content = json.dumps(payload, separators=(',', ':'))
    
    print("Headers being sent:")
    for k, v in headers.items():
        print(f"  {k}: {v}")
    
    print(f"\nPayload size: {len(json_content)} bytes")
    print(f"Content-Length: {len(json_content.encode('utf-8'))}")
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                URL, 
                content=json_content, 
                headers=headers, 
                timeout=30.0
            )
            
            print(f"\nResponse Status: {response.status_code}")
            print("Response Headers:")
            for k, v in response.headers.items():
                print(f"  {k}: {v}")
            
            if response.status_code == 200:
                print("✅ SUCCESS with httpx (raw content)!")
                return True
            else:
                print(f"❌ FAILED with httpx (raw content): {response.status_code}")
                print(f"Response: {response.text}")
                return False
                
    except Exception as e:
        print(f"❌ EXCEPTION with httpx (raw content): {e}")
        return False


async def main():
    """Run all tests to compare requests vs httpx"""
    print("🔬 INVESTIGATING HTTPX vs REQUESTS DIFFERENCES")
    print("=" * 60)
    
    if not API_KEY:
        print("❌ ERROR: SERVICENOW_TOKEN not set!")
        return
    
    print(f"API Key: {API_KEY[:15]}...")
    print(f"Target URL: {URL}")
    print()
    
    # Test 1: requests (known working)
    requests_works = test_with_requests()
    
    # Test 2: httpx minimal
    httpx_minimal_works = await test_with_httpx_minimal()
    
    # Test 3: httpx with client headers
    httpx_client_works = await test_with_httpx_configured()
    
    # Test 4: httpx with raw content
    httpx_raw_works = await test_with_httpx_raw()
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 SUMMARY:")
    print(f"  Requests:                {'✅ WORKS' if requests_works else '❌ FAILS'}")
    print(f"  httpx (minimal):         {'✅ WORKS' if httpx_minimal_works else '❌ FAILS'}")
    print(f"  httpx (client headers):  {'✅ WORKS' if httpx_client_works else '❌ FAILS'}")
    print(f"  httpx (raw content):     {'✅ WORKS' if httpx_raw_works else '❌ FAILS'}")
    
    if requests_works and not any([httpx_minimal_works, httpx_client_works, httpx_raw_works]):
        print("\n🔍 CONCLUSION: httpx has fundamental incompatibility with ServiceNow")
        print("   Recommendation: Use requests library for ServiceNow A2A integration")
    elif any([httpx_minimal_works, httpx_client_works, httpx_raw_works]):
        print("\n✅ CONCLUSION: Found working httpx configuration!")
        if httpx_minimal_works:
            print("   Use httpx with minimal headers passed to request")
        elif httpx_client_works:
            print("   Use httpx with headers configured at client level")
        elif httpx_raw_works:
            print("   Use httpx with raw content instead of json parameter")


if __name__ == "__main__":
    asyncio.run(main())
