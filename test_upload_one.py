import urllib.request
import urllib.error
import json
import time

API_KEY = "YtxB+TRlPU6v5MyNdpLS+29Gmn6fn2LYYZHeDRKjxP5q4JFuZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaGRXUWlPaUpTYjJKc2IzaEpiblJsY201aGJDSXNJbWx6Y3lJNklrTnNiM1ZrUVhWMGFHVnVkR2xqWVhScGIyNVRaWEoyYVdObElpd2lZbUZ6WlVGd2FVdGxlU0k2SWxsMGVFSXJWRkpzVUZVMmRqVk5lVTVrY0V4VEt6STVSMjF1Tm1adU1reFpXVnBJWlVSU1MycDRVRFZ4TkVwR2RTSXNJbTkzYm1WeVNXUWlPaUl4TVRrM05qRXhPak15TXlJc0ltVjRjQ0k2TVRjNU5ETTJNakEyTXl3aWFXRjBJam94TnprME16VTRORFl6TENKdVltWWlPakUzT1RRek5UZzBOak45LkdrTVFiOWE1SDdzQVZzZW9rX29UbXZCdmtIRTZ0RTZnZnZiSnNhMjlwQ1F4V2djT2V3Q0c4a3VWdnotSkk1aEdUdTRBWHpoMU12T0pEZWFwSW0zLVJ3VHJqeGdBaHUtUlpiNWRwRklZOXpiNGYwVmdpRkxRUDMxNkxwZVF2MWFUWnBsZnRFdHVxMDJIQUlIX3MwME52eU8tSUtpeW0tbmNGRklma0V0d3hLSmhBZTZnWTdjSUhWTXpoQU82S1RTS1AxMGpnMjdLUnlmMjlEU29zR1U3b25PWVFIUi1mbTE4V1V1Tk5LNjJFVW9pdXdlLVZCV0Y1amk4NEtPUGdYTkJFV21lQ1dReXRYUUYyTlBubkxILUhYWjEwSzllaUhPTlpGTDhYc0EySTEzdjNiUjY5RDlaa2FHTFhkTHkyeDVKMFdwWTVUSUFIZk1Nb3lLZnZnTVRlUQ=="
CREATOR_USER_ID = "11976112323"

file_path = 'assets_ready_to_upload/case_001_intraoral.jpg'
boundary = '----WebKitFormBoundary7MA4YWxkTrZu0gW'

metadata = {
    'assetType': 'Image',
    'displayName': 'case_001_intraoral',
    'description': 'OSCE Dental Case Clinical Image',
    'creationContext': {
        'creator': {
            'userId': CREATOR_USER_ID
        }
    }
}

body = bytearray()
body.extend(f'--{boundary}\r\n'.encode('utf-8'))
body.extend(b'Content-Disposition: form-data; name="request"\r\n')
body.extend(b'Content-Type: application/json\r\n\r\n')
body.extend(json.dumps(metadata).encode('utf-8'))
body.extend(b'\r\n')

body.extend(f'--{boundary}\r\n'.encode('utf-8'))
body.extend(b'Content-Disposition: form-data; name="fileContent"; filename="case_001_intraoral.jpg"\r\n')
body.extend(b'Content-Type: image/jpeg\r\n\r\n')
with open(file_path, 'rb') as f:
    body.extend(f.read())
body.extend(b'\r\n')
body.extend(f'--{boundary}--\r\n'.encode('utf-8'))

req = urllib.request.Request('https://apis.roblox.com/assets/v1/assets', data=body, method='POST')
req.add_header('x-api-key', API_KEY)
req.add_header('Content-Type', f'multipart/form-data; boundary={boundary}')

try:
    with urllib.request.urlopen(req) as resp:
        res = json.loads(resp.read().decode('utf-8'))
        print('SUCCESS! Response:', json.dumps(res, indent=2))
        op_path = res.get('path')
        if op_path:
            op_url = f"https://apis.roblox.com/assets/v1/{op_path}"
            for i in range(15):
                time.sleep(1.5)
                op_req = urllib.request.Request(op_url)
                op_req.add_header('x-api-key', API_KEY)
                with urllib.request.urlopen(op_req) as op_resp:
                    op_data = json.loads(op_resp.read().decode('utf-8'))
                    print(f"Polling {i+1}: done={op_data.get('done')}")
                    if op_data.get('done'):
                        err = op_data.get('error')
                        if err:
                            print(f"❌ Error/Moderation:", json.dumps(err, indent=2))
                        else:
                            print(f"🎉 APPROVED! Asset ID:", op_data.get('response', {}).get('assetId'))
                        break
except urllib.error.HTTPError as e:
    print('HTTP Error:', e.code)
    print(e.read().decode('utf-8'))
