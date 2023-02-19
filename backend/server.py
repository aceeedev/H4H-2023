from flask import Flask, jsonify, request
from event import EventManager
import requests
import os

app = Flask(__name__)
key = os.environ.get("GOOGLE_TOKEN")
print(key)
google_endpoint = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"


all_books = []
# [homeless-shelter, soup-kitchen, food-drive, homeless-service, homeless-hospital]

@app.route('/')
def home():
    return "<h1>go to home/find_event to find a qrcode for an event</h1>"

@app.route('/populate')
def populate():
    lat = request.args.get('lat', default = 0, type = float)
    long =  request.args.get('long', default = 0, type = float)
    keyword = request.args.get("query", default="", type=str)
    payload = {
        "key": key,
        "keyword": keyword,
        "radius": 1500,
        "location": f"{lat},{long}",
        
    }
    response = requests.get(url=google_endpoint, params=payload)
    print(response.status_code)
    print(response.json())
    return response.json()






@app.route("/find_event")
def add():
    payload = jsonify({
        "time": "7:30",
        "name": "soup kitchen",
        "location": "500 El Camino Real"
    })
    return payload
    


if __name__ == "__main__":
    app.run(debug=True)