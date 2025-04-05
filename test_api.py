import requests

url = "http://127.0.0.1:8000/predict/"  # Update if your endpoint is different

data = {
    "marital_status": "Single",
    "application_mode": "Online",
    "application_order": 1
}

response = requests.post(url, json=data)

print(response.json())  # Should return prediction
