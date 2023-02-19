class EventManager:
    def create_event(self, time: str, name: str, location: str, coords: list[float], description = ""):
        return ({
            "time": time,
            "name": name,
            "location": location,
            "coords": coords,
            "description": description
        })