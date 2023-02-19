from flask import Flask, jsonify, request
from event_manager import EventManager


app = Flask(__name__)
driver = EventManager()

@app.route('/')
def home():
    return "<h1>go to /findevents to find a qrcode for an event</h1>"\
            "<h1>go to /completeaddress to get an autocomplete feature</h1>"


@app.route('/findevents')
def populate():
    lat = request.args.get('lat', default = 0, type = float)
    long =  request.args.get('long', default = 0, type = float)
    keyword = request.args.get("query", default="", type=str)
    
    ids = driver.find_ids(lat=lat, long=long, keyword=keyword)
    
    return jsonify(driver.search_locations_by_id(ids=ids))

@app.route("/completeaddress")
def complete_address():
    lat = request.args.get('lat', default = 0, type = float)
    long =  request.args.get('long', default = 0, type = float)
    address = request.args.get("address", default="", type=str)
    return jsonify(driver.address_autocomplete(lat=str(lat), long=str(long), address=address))


if __name__ == "__main__":
    app.run(debug=True)