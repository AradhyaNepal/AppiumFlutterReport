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

    def test_completed(self, extra_log: str, status: str, invalid_grouping: bool = False):
        if self.invalid_grouping_lock is True:
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

    def get_json_status(self) -> str:
        match self.status:
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
            all_children_skipped = True
            all_children_none = True
            for item in self.children:
                item: TestCaseData = item
                children_status = item.get_status_from_children()
                if children_statusis is Status.ERROR:
                    # First Priority
                    return Status.ERROR
                if children_status is Status.FAILED:
                    some_test_failed = some_test_failed or True
                if children_status is not Status.SKIPPED:
                    all_children_skipped = all_children_skipped and False
                if children_status is not Status.NONE:
                    all_children_none = all_children_none and False

            # Returning as per the priority
            if some_test_failed:
                return Status.FAILED
            elif all_children_skipped:
                return Status.SKIPPED
            elif all_children_none:
                return Status.NONE
            else:
                return Status.SUCCESS

    def no_need_to_search_children(self) -> bool:
        if self.children is None:
            return True
        return self.status is Status.SKIPPED or self.is_group is False or len(self.children) == 0

    def to_json(self):
        print("called")
        response = {
            "time": self.time,
            "status": self.get_status_from_children(),
            "testName": self.test_name,
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


class Status():
    SUCCESS = 1
    FAILED = 2
    ERROR = 3
    SKIPPED = 4
    NONE = 5
