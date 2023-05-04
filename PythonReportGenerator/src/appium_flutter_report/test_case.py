from datetime import datetime


class TestCaseData:
    def __init__(self, test_name: str, is_group: bool):
        self.time: datetime = datetime.now()
        self.status = Status.NONE
        self.test_name = test_name
        self.steps = []
        self.screenshots = []
        self.is_group = is_group
        self.children = [] if is_group else None
        self.invalid_grouping_lock = False
        self.extra_log = "N/A"

    def test_completed(self, extra_log: str, status: int, invalid_grouping: bool = False):
        if self.invalid_grouping_lock is True:
            print("Locked Protection")
            return
        self.invalid_grouping_lock = invalid_grouping
        self.extra_log = extra_log
        self.status = status
        duration = datetime.now() - self.time
        self.duration = str(duration.total_seconds() * 1000) + " ms"

    def add_step(self, step: str):
        self.steps.append(step)

    def add_screenshot(self, screenshot: str):
        self.screenshots.append(screenshot)

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

    def to_json(self):
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
            for item in self.children:
                item: TestCaseData = item
                children_json.append(item.to_json())
            response["children"] = children_json

        return response


class Status:
    SUCCESS = 1
    FAILED = 2
    ERROR = 3
    SKIPPED = 4
    NONE = 5
