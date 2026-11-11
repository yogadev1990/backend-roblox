import os
import json
import time
import urllib.request
import urllib.error

API_KEY = "KHKOEvpfOUO//i9kYj1cPzLSv29+Y6Zwe60M0T3EY01LGfRfZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaGRXUWlPaUpTYjJKc2IzaEpiblJsY201aGJDSXNJbWx6Y3lJNklrTnNiM1ZrUVhWMGFHVnVkR2xqWVhScGIyNVRaWEoyYVdObElpd2lZbUZ6WlVGd2FVdGxlU0k2SWt0SVMwOUZkbkJtVDFWUEx5OXBPV3RaYWpGalVIcE1VM1l5T1N0Wk5scDNaVFl3VFRCVU0wVlpNREZNUjJaU1ppSXNJbTkzYm1WeVNXUWlPaUk1T0RnMk1EazJORFUzSWl3aVpYaHdJam94TnprME16WTVOVFkwTENKcFlYUWlPakUzT1RRek5qVTVOalFzSW01aVppSTZNVGM1TkRNMk5UazJOSDAuSlRWWGdKM0lTclBZTkN4V0ZJTmlWZWtEbENhdmJlLVZ5ZElqTDRadVhvdjJReHFHMDJpMHBZNjBuM1pNYTB6Vk51Nl8tX1VhVk54M01BWjdNRkdibGY1eTRuRF9oZHgtN1MtZnFkb3dKeGF2aThiWE5YWUNmeWp3VFRzcWpNNzlvNmxnclR6T3JITDdSNGFmWmZMZUliXzhHOWZDYXVWZXpKb25tZVRCSVBxMGpWVWNQcWRHV2ZVTUlHS0RXbUVKaTBReUhDUW5lSjhvRXZFd3RYMzFOZl9RLWFabFB3RHdJYk12Z29xNmNmN3lMZV9WUVdoenVqcUQwWFc4WjBORmNqOFBnVjZNVWxUeG8xOFFicGFwTmNPOU9GRmFCZDFxZU0yWFB6VzluLW8wNU9KTkRwY3ZqWTZ1dGhpOW5Lci1Na0E0Q1ZuZUxrS2NuOEc4cFlYTEx3"
CREATOR_USER_ID = "9886096457"
FILE_PATH = "assets_ready_to_upload/case_017_intraoral.jpg"
DISPLAY_NAME = "case_017_intraoral_v2"

url = "https://apis.roblox.com/assets/v1/assets"
boundary = f"----Boundary{int(time.time()*1000)}"

metadata = {
    "assetType": "Image",
    "displayName": DISPLAY_NAME,
    "description": f"OSCE Clinical Pre-test: {DISPLAY_NAME}",
    "creationContext": {
        "creator": {
            "userId": CREATOR_USER_ID
        }
    }
}

body = bytearray()
body.extend(f'--{boundary}\r\n'.encode('utf-8'))
body.extend(b'Content-Disposition: form-data; name="request"\r\n')
body.extend(b'Content-Type: application/json\r\n\r\n')
body.extend(json.dumps(metadata).encode('utf-8'))
body.extend(b'\r\n')

fname = os.path.basename(FILE_PATH)
body.extend(f'--{boundary}\r\n'.encode('utf-8'))
body.extend(f'Content-Disposition: form-data; name="fileContent"; filename="{fname}"\r\n'.encode('utf-8'))
body.extend(b'Content-Type: image/jpeg\r\n\r\n')
with open(FILE_PATH, 'rb') as f:
    body.extend(f.read())
body.extend(b'\r\n')
body.extend(f'--{boundary}--\r\n'.encode('utf-8'))

req = urllib.request.Request(url, data=body, method='POST')
req.add_header('x-api-key', API_KEY)
req.add_header('Content-Type', f'multipart/form-data; boundary={boundary}')

try:
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read().decode('utf-8'))
        op_path = data.get('path')
        if not op_path:
            asset_id = data.get('response', {}).get('assetId')
            print("Direct Asset ID:", asset_id)
        else:
            op_url = f"https://apis.roblox.com/assets/v1/{op_path}"
            for _ in range(25):
                time.sleep(1.5)
                op_req = urllib.request.Request(op_url)
                op_req.add_header('x-api-key', API_KEY)
                with urllib.request.urlopen(op_req) as op_resp:
                    op_data = json.loads(op_resp.read().decode('utf-8'))
                    if op_data.get('done'):
                        err = op_data.get('error')
                        if err:
                            print("Error:", err)
                            break
                        asset_id = op_data.get('response', {}).get('assetId')
                        print("✅ Successfully uploaded! New Asset ID:", asset_id)
                        break
except Exception as e:
    print("Failed:", e)

