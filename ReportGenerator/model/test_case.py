class TestCaseData:
    def __init__(self, test_name: str, is_group: bool):
        self.time = datetime.datetime.now()
        # Success, Failed, Error
        self.status = Status.NONE
        self.test_name = test_name
        self.steps = []
        self.screenshots = []
        self.is_group = is_group
        self.children = [] if isGroup else None
        self.invalid_grouping = False

    def test_completed(self, extra_log: String, status: str, invalid_grouping: bool = False):
        if self.invalid_grouping is True and self.is_group is not True:
            return
        self.invalid_grouping = invalid_grouping
        self.duration = datetime.datetime.now() - self.time
        self.extra_log = extra_log
        self.status = status

    def add_step(self, step: String):
        self.steps.append(step)

    def add_screenshot(self, screenshot: String):
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

    def get_status_from_children(self) -> Status:
        if no_need_to_search_children():
            return self.status
        else:
            have_failed_too = False
            all_children_skipped = True
            all_children_none = True
            for item in self.children:
                item: TestCaseData = item
                children_status = item.get_status_from_children()
                if children_statusis is Status.ERROR:
                    # First Priority
                    return Status.ERROR
                if children_status is Status.FAILED:
                    have_failed_too = have_failed_too or True
                if children_status is not Status.SKIPPED:
                    all_children_skipped = all_children_skipped and False
                if children_status is not Status.NONE:
                    all_children_none = all_children_none and False

            # Returning as per the priority
            if have_failed_too:
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
        return self.status is Status.SKIPPED or self.is_group is False or len(self.children) is False


class Status(Enum):
    SUCCESS = 1
    FAILED = 2
    ERROR = 3
    SKIPPED = 4
    NONE = 5
