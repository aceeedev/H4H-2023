from flask import Flask, jsonify, request
import qrcode

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