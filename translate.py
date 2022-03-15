import os
import sys
import json
import requests
from dotenv import load_dotenv

load_dotenv()
token = os.environ.get("API_TOKEN")

sentence = sys.argv[1]

headers = {"Authorization": f"Bearer {token}"}
API_URL = "https://api-inference.huggingface.co/models/facebook/blenderbot_small-90M"

def query(payload):
    data = json.dumps(payload)
    response = requests.request("POST", API_URL, headers=headers, data=data)
    return json.loads(response.content.decode("utf-8"))

data = query(
    {
        "inputs": "Меня зовут Вольфганг и я живу в Берлине",
    }
)

print(data)