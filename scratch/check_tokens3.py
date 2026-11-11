import base64
import json
import re

with open('bulk_upload_all_assets.py') as f:
    code = f.read()

m = re.search(r'API_KEY\s*=\s*"([^"]+)"', code)
key1 = m.group(1)
decoded = base64.b64decode(key1)
idx = decoded.find(b'eyJ')
jwt_part = decoded[idx:].decode('utf-8', errors='ignore')
parts = jwt_part.split('.')
payload = parts[1]
padded = payload + '=' * (-len(payload) % 4)
print("bulk_upload_all_assets.py Payload:", base64.b64decode(padded).decode('utf-8'))

