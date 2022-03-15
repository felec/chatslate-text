import os
import sys
import json
import requests
from dotenv import load_dotenv

load_dotenv()
token = os.environ.get("API_TOKEN")

trans_sentence = sys.argv[1]
slug = sys.argv[2]

headers = {"Authorization": f"Bearer {token}"}
API_URL = f'https://api-inference.huggingface.co/models/Helsinki-NLP/opus-mt-{slug}'

def query(payload):
    data = json.dumps(payload)
    response = requests.request("POST", API_URL, headers=headers, data=data)
    return json.loads(response.content.decode("utf-8"))

data = query(
    {
        "inputs": trans_sentence,
    }
)

print(data)