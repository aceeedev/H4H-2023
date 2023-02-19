class EventManager:
    def create_event(self, time: str, name: str, cords: list[float], location: str, description=None):
        return ({
            "time": time,
            "name": name,
            "cords": cords,
            "location": location,
            "description": description
        })
    
    def find_address(self, address_components: list[dict]):

        address = ""
        count = 0
        for component in address_components:
            count += 1
            if count == 3:
                continue
            print(count)
            address += component["long_name"] + " "
            if count == 4:
                break
        
        print(address)
        return address 
            

