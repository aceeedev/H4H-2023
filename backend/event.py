class EventManager:
    def create_event(self, time: str, name: str, location: list[float], description: str):
        return ({
            "time": time,
            "name": name,
            "location": location,
            "description": description
        })