from flask import Flask, jsonify, request
from event import EventManager
import requests
import os
from dotenv import load_dotenv
import heapq

load_dotenv()
key = os.environ.get("GOOGLE_TOKEN")
print(key)

url_nearby_search = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
url_details = "https://maps.googleapis.com/maps/api/place/details/json"


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
    # make calls for ids here (you should expect 3 or less perhaps zero make sure you check)
    
    # return jsonify({"ids": ids})
    # make calls here

    driver = EventManager()

    result = []

    for id in ids:
        payload = {
            "key": key,
            "fields": "name,current_opening_hours,geometry,address_components",
            "place_id": id,   
        }

        response = requests.get(url=url_details, params=payload)    

        data = response.json()["result"]

        if "current_opening_hours" in data:
            time = data["current_opening_hours"]["weekday_text"][0]
            print(time)

        else:
            time = "unknown"

        name = data["name"]

        location = "temp"

        if "geometry" in data:
            lat_long = data["geometry"]["location"]
            coords = [ lat_long["lat"], lat_long["lng"] ]
            

        result.append(driver.create_event(time, name, location, coords))
    
    return jsonify(result)

def find_ids(lat, long, keyword) -> list[str]:
    payload = {
        "key": key,
        "keyword": keyword,
        "radius": 1500,
        "location": f"{lat},{long}",
        
    }
    response = requests.get(url=url_nearby_search, params=payload)
    # return response.json()
    results = []
    for result in response.json()["results"]:
        if "rating" in result and "user_ratings_total" in result:
            results.append((result["rating"] * result["user_ratings_total"], result["place_id"]))
    
    n = 3 if len(results) > 3 else len(results)
    ids = heapq.nlargest(n, results)
    return [id[1] for id in ids]


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