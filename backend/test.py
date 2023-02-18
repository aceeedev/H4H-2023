import requests

endpoint = "https://opentdb.com/api.php?amount=10&type=boolean"
response = requests.get(url=endpoint )

print(response.status_code, response.json())