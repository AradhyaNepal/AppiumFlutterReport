
class TestCaseData:
    def __init__(self, test_name: String, is_group: bool):
        self.time = datetime.datetime.now()
        # Success, Failed, Error
        self.status = "Skipped"
        self.test_name = test_name
        self.steps = []
        self.screenshots = []
        self.children = [] if isGroup else None

    def test_completed(self, extra_log: String):
        self.duration = datetime.datetime.now()-self.time
        self.extra_log = extra_log

    def add_step(self, step: String):
        self.steps.append(step)

    def add_screenshot(self, screenshot: String):
        self.screenshots.append(screenshot)

