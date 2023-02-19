from flask import Flask, jsonify, request
from event_manager import EventManager


app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>go to home/find_event to find a qrcode for an event</h1>"

@app.route('/populate')
def populate():
    lat = request.args.get('lat', default = 0, type = float)
    long =  request.args.get('long', default = 0, type = float)
    keyword = request.args.get("query", default="", type=str)
    
    driver = EventManager()
    ids = driver.find_ids(lat=lat, long=long, keyword=keyword)
    
    return jsonify(driver.search_locations_by_id(ids=ids))


if __name__ == "__main__":
    app.run(debug=True)