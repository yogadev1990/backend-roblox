import base64
import json

with open('new_api_key.txt') as f:
    key2 = f.read().strip()

print("Key length:", len(key2))
try:
    decoded = base64.b64decode(key2)
    print("Base64 decoded length:", len(decoded))
    # see if there's any text
    print("Decoded preview:", repr(decoded[:100]))
    # look for eyJ in decoded
    idx = decoded.find(b'eyJ')
    if idx != -1:
        jwt_part = decoded[idx:].decode('utf-8', errors='ignore')
        parts = jwt_part.split('.')
        payload = parts[1]
        padded = payload + '=' * (-len(payload) % 4)
        print("Payload:", base64.b64decode(padded).decode('utf-8'))
except Exception as e:
    print("Error:", e)

