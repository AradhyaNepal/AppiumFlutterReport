from src.test_case import TestCaseData


# Logger is available to user. It ensure that user can add details to TestCaseData's Object
# Yet Logger ensure that user cannot modify sensitive data from TestCaseData's Object
class Logger:
    def __init__(self, data: TestCaseData):
        self.__privateData = data

    def add_step(self, step: str):
        self.__privateData.add_step(step)

    def add_screenshot(self, screenshot: str):
        self.__privateData.add_screenshot(screenshot)

