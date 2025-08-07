import requests
import base64

# === Identifiants SANDBOX ===
CLIENT_ID = "ndeyemba-MbayeFul-SBX-13649ae1c2ecc-4c3c-4a7e-a7fa-258e"
CLIENT_SECRET = "SBX-3649ae1c2ecc-4c3c-4a7e-a7fa-258e"

TOKEN_URL = "https://api.sandbox.ebay.com/identity/v1/oauth2/token"

credentials = f"{CLIENT_ID}:{CLIENT_SECRET}"
encoded_credentials = base64.b64encode(credentials.encode()).decode()

headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": f"Basic {encoded_credentials}"
}

data = {
    "grant_type": "client_credentials",
    "scope": "https://api.ebay.com/oauth/api_scope"
}

response = requests.post(TOKEN_URL, headers=headers, data=data)

if response.status_code == 200:
    token_data = response.json()
    access_token = token_data.get("access_token")
    print(access_token)  # SEULE sortie pour token
else:
    print(f"❌ Échec ({response.status_code})")
    print(response.text)
