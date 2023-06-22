class Video:
    def __init__(self, video_location: str, thumbnail_location: str):
        self.video_location = video_location
        self.thumbnail_location = thumbnail_location

    def to_json(self) -> dict:
        return {
            "video": self.video_location,
            "thumbnail": self.thumbnail_location,
        }
