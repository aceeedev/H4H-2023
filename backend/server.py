from flask import Flask, jsonify, request
from event import EventManager
import requests
import os
from dotenv import load_dotenv

load_dotenv()
key = os.environ.get("GOOGLE_TOKEN")
print(key)
url_nearby_search = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
app = Flask(__name__)

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
    
    ids = find_ids(lat=lat, long=long, keyword=keyword)
    # make calls here

def find_ids(lat, long, keyword) -> list[str]:
    payload = {
        "key": key,
        "keyword": keyword,
        "radius": 1500,
        "location": f"{lat},{long}",
        
    }
    response = requests.get(url=url_nearby_search, params=payload)
    ids = []
    for result in response.json()["results"]:
        if "place_id" in result: ids.append(result["place_id"])
    return ids


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