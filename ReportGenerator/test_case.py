
class TestCaseData:
    def __init__(self, test_name: str, is_group: bool):
        self.time = datetime.datetime.now()
        # Success, Failed, Error
        self.status = None
        self.test_name = test_name
        self.steps = []
        self.screenshots = []
        self.is_group=is_group
        self.children = [] if isGroup else None
        self.invalid_grouping= False


    def test_completed(self, extra_log: String, status: str, invalid_grouping:bool=False):
        if self.invalid_grouping is True and self.is_group is not True:
            return
        self.invalid_grouping=invalid_grouping
        self.duration = datetime.datetime.now()-self.time
        self.extra_log = extra_log
        self.status= status

    def add_step(self, step: String):
        self.steps.append(step)

    def add_screenshot(self, screenshot: String):
        self.screenshots.append(screenshot)

