import base64
import json
import re

def decode_token(tok):
    try:
        idx = tok.find('eyJ')
        if idx == -1: return "No eyJ found"
        jwt_part = tok[idx:]
        parts = jwt_part.split('.')
        payload = parts[1]
        padded = payload + '=' * (-len(payload) % 4)
        data = base64.b64decode(padded).decode('utf-8')
        return json.loads(data)
    except Exception as e:
        return str(e)

with open('bulk_upload_all_assets.py') as f:
    code = f.read()

m1 = re.search(r'API_KEY\s*=\s*"([^"]+)"', code)
if m1:
    print("bulk_upload_all_assets.py token payload:")
    print(json.dumps(decode_token(m1.group(1)), indent=2))

with open('new_api_key.txt') as f:
    key2 = f.read().strip()
    print("\nnew_api_key.txt token payload:")
    print(json.dumps(decode_token(key2), indent=2))

