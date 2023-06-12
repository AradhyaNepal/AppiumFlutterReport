from .test_case import TestCaseData
from report_generator import FlutterReportGenerator
from appium import webdriver


# Logger is available to user. It ensure that user can add details to TestCaseData's Object
# Yet Logger ensure that user cannot modify sensitive data from TestCaseData's Object
class Logger:
    def __init__(self, data: TestCaseData):
        self.__privateData = data
        self.is_recoding = False

    def add_step(self, step: str):
        self.__privateData.add_step(step)

    def add_error(self, step: str):
        self.__privateData.add_error(step)

    def add_warning(self, warning: str):
        self.__privateData.add_warning(warning)

    def add_screenshot(self):
        location = '/screenshot/' + "Error_" + self.__privateData.test_name[0:10] + "_" + datetime.now().strftime(
            "%H:%M:%S") + ".png"
        driver: webdriver.Remote = FlutterReportGenerator.driver
        image = driver.get_screenshot_as_png()
        with open(location, 'wb') as f:
            f.write(image)
        self.__privateData.add_screenshot(location)

    def start_recording(self):
        if self.is_recording is False:
            self.is_recoding = True
            driver: webdriver.Remote = FlutterReportGenerator.driver
            driver.start_recording_screen()
        else:
            print("Already recording, cannot record " + self.__privateData.test_name)

    def stop_and_save_recording(self, auto_stop: bool = False):
        if self.is_recoding is True:
            self.is_recoding = False
            driver: webdriver.Remote = FlutterReportGenerator.driver
            video = driver.stop_recording_screen()
            location = '/video/' + "Error_" + self.__privateData.test_name[0:10] + "_" + datetime.now().strftime(
                "%H:%M:%S") + ".mp4"
            with open(location, 'wb') as f:
                f.write(video)
            self.__privateData.add_video(location)
        else:
            if auto_stop:
                return
            print("Nothing is recoding in " + self.__privateData.test_name)
