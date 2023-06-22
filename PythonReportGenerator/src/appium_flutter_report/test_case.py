from datetime import datetime
from .video import Video


class TestCaseData:
    def __init__(self, test_name: str, is_group: bool):
        self.time: datetime = datetime.now()
        self.status = Status.NONE
        self.test_name = test_name
        self.warning = ""
        self.steps = []
        self.screenshots = []
        self.videos = []
        self.is_group = is_group
        self.children = [] if is_group else None
        self.extra_log = "_"

    def test_completed(self, extra_log: str, status: int):
        self.extra_log = extra_log
        self.status = status
        duration = datetime.now() - self.time
        self.duration = str(duration.total_seconds() * 1000) + " ms"

    def add_step(self, step: str):
        self.steps.append(step)

    def add_warning(self, warning: str):
        self.warning = self.warning + "\n" + warning

    def add_screenshot(self, screenshot: str):
        self.screenshots.append(screenshot)

    def add_video(self, video: Video):
        self.videos.append(video)

    @staticmethod
    def get_json_status(status: int) -> str:
        match status:
            case Status.SUCCESS:
                return "Success"
            case Status.FAILED:
                return "Failed"
            case Status.ERROR:
                return "Error"
            case Status.SKIPPED:
                return "Skipped"
            case Status.NONE:
                return "None"

    def get_status_from_children(self):
        if self.no_need_to_search_children():
            return self.status
        else:
            some_test_failed = False
            for item in self.children:
                item: TestCaseData = item
                children_status = item.get_status_from_children()
                if children_status is Status.ERROR:
                    # First Priority
                    return Status.ERROR
                if children_status is Status.ERROR:
                    some_test_failed = some_test_failed or True

            # Returning as per the priority
            if some_test_failed:
                return Status.FAILED
            else:
                return Status.SUCCESS

    def no_need_to_search_children(self) -> bool:
        if self.children is None:
            return True
        return self.status is Status.SKIPPED or self.is_group is False or len(self.children) == 0

    def to_json(self) -> dict:
        response = {
            "testName": self.test_name,
            "time": self.time,
            "status": TestCaseData.get_json_status(self.get_status_from_children()),
            "extraLog": self.extra_log,
            "duration": self.duration,
            "steps": self.steps,
            "screenshots": self.screenshots,
        }
        if self.is_group is True or self.children is not None:
            children_json = []
            for child in self.children:
                child: TestCaseData = child
                children_json.append(child.to_json())
            response["children"] = children_json
        video_json = []
        for video in self.videos:
            video: Video = video
            video_json.append(video.to_json())
        response["videos"] = video_json

        return response


class Status:
    SUCCESS = 1
    FAILED = 2
    ERROR = 3
    SKIPPED = 4
    NONE = 5
