class EventManager:
    def create_event(self, time: str, name: str, cords: list[float], location: str, description=""):
        return ({
            "time": time,
            "name": name,
            "cords": cords,
            "location": location,
            "description": description
        })
    
    def find_address(self, address_components: list[dict]):

        address = ""
        for component in address_components:
            address += component["long_name"]
            if "locality" or "political" in component["types"]: 
                break
        print(address)
        return address 
            

