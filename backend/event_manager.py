import requests
import heapq
import os
from dotenv import load_dotenv

load_dotenv()

class EventManager:
    def __init__(self) -> None:
        self.url_nearby_search = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        self.url_details = "https://maps.googleapis.com/maps/api/place/details/json"
        self.url_auto_complete = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        self.key = os.environ.get("GOOGLE_TOKEN")

    
    def create_event(self, time: list[str], name: str, cords: list[float], location: str, description=None) -> dict:
        '''returns the desired dictionary object to be converted into a json object'''
        return ({
            "time": time,
            "name": name,
            "cords": cords,
            "location": location,
            "description": description
        })
    
    
    def find_ids(self, lat: str, long: str, keyword: str) -> list[str]:
        '''finds the top 3 user query results based on user reviews'''
        payload = {
            "key": self.key,
            "keyword": keyword,
            "radius": 1500,
            "location": f"{lat},{long}",
            
        }
        response = requests.get(url=self.url_nearby_search, params=payload)
        response.raise_for_status()

        results = []
        for result in response.json()["results"]:
            if "rating" in result and "user_ratings_total" in result:
                results.append((result["rating"] * result["user_ratings_total"], result["place_id"]))
        
        n = 3 if len(results) > 3 else len(results)
        ids = heapq.nlargest(n, results)
        return [id[1] for id in ids]
    
    
    def find_address(self, address_components: list[dict]):
        '''cleans the address into a readable format'''
        address = ""
        count = 0
        for component in address_components[:4]:
            count += 1
            if count == 3:
                continue
            address += component["long_name"] + " "
        
        return address 
    
    
    def search_locations_by_id(self, ids: list[str]) -> list[dict]:
        '''finds the hours of operation and event data for the dict object'''
        result = []
        for id in ids:
            payload = {
                "key": self.key,
                "fields": "name,current_opening_hours,geometry,address_components",
                "place_id": id,   
            }

            response = requests.get(url=self.url_details, params=payload)    

            data = response.json()["result"]

            if "current_opening_hours" in data:
                start = data["current_opening_hours"]["periods"][0]["open"]["time"]
                end = data["current_opening_hours"]["periods"][0]["close"]["time"]

                start = start[:2] + ":" + start[2:]
                end = end[:2] + ":" + end[2:]

                time = [start, end]

            else:
                time = None

            name = data["name"]

            location = self.find_address(data["address_components"])

            if "geometry" in data:
                lat_long = data["geometry"]["location"]
                coords = [ lat_long["lat"], lat_long["lng"] ]
                

            result.append(self.create_event(time=time, name=name, cords=coords, location=location))

        return result
    
    
    def address_autocomplete(self, address: str) -> list:
        payload = {'input': address, 'key': self.key, 'radius': 50000}
        response = requests.get(url=self.url_auto_complete, params=payload)
        predictions = response.json()["predictions"]
        
        # places stores the location and a key to get the lat and long
        ids = []
        for location in predictions:
                ids.append([location["place_id"], location["description"]])
        
        locations =  self.search_locations_by_id(ids)
        results = []
        for i in range(len(ids)):
            results.append({"location": ids[i][1], "cords": locations[i]["cords"]})
            
        return results

