import os
import sys
import json
import requests
from dotenv import load_dotenv

load_dotenv()
token = os.environ.get("API_TOKEN")

new_sentence = sys.argv[1]
# past_sentences = sys.argv[2]
# past_responses = sys.argv[3]

headers = {"Authorization": f"Bearer {token}"}
API_URL = "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill"

def query(payload):
    data = json.dumps(payload)
    response = requests.request("POST", API_URL, headers=headers, data=data)
    return json.loads(response.content.decode("utf-8"))

data = query(
    {
        "inputs": {
            # "past_user_inputs": ["Which movie is the best ?"],
            # "generated_responses": ["It's Die Hard for sure."],
            "text": new_sentence,
        },
    }
)

print(data['generated_text'])
sys.exit(0)