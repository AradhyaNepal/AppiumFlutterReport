from .test_case import TestCaseData
from .report_generator import FlutterReportGenerator
from appium import webdriver
from datetime import datetime
import os
import base64


# Logger is available to user. It ensure that user can add details to TestCaseData's Object
# Yet Logger ensure that user cannot modify sensitive data from TestCaseData's Object
class Logger:
    def __init__(self, data: TestCaseData):
        self.__privateData = data
        self.is_recording = False

    def add_step(self, step: str):
        self.__privateData.add_step(step)

    def add_error(self, step: str):
        self.__privateData.add_error(step)

    def add_warning(self, warning: str):
        self.__privateData.add_warning(warning)

    def add_screenshot(self):
        directory = FlutterReportGenerator.report_path + 'screenshot/'
        if not os.path.exists(directory):
            os.makedirs(directory)
        location = directory + "Error_" + self.__privateData.test_name.replace(
            " ",
            "_") + "_" + datetime.now().strftime(
            "%d_%m_%Y") + ".png"
        driver: webdriver.Remote = FlutterReportGenerator.driver
        print("Taking Screenshot")
        image = driver.get_screenshot_as_png()
        with open(location, 'wb') as f:
            f.write(image)
        self.__privateData.add_screenshot(location)

    def start_recording(self):
        if self.is_recording is False:
            self.is_recording = True
            print("Recording Started")
            driver: webdriver.Remote = FlutterReportGenerator.driver
            driver.switch_to.context("NATIVE_APP")
            driver.start_recording_screen()
            driver.switch_to.context("FLUTTER")
        else:
            print("Already recording, cannot record " + self.__privateData.test_name)

    def stop_and_save_recording(self, auto_stop: bool = False):
        if self.is_recording is True:
            self.is_recording = False
            driver: webdriver.Remote = FlutterReportGenerator.driver
            print("Recording Stopped")
            driver.switch_to.context("NATIVE_APP")
            video = driver.stop_recording_screen()
            driver.switch_to.context("FLUTTER")
            directory=FlutterReportGenerator.report_path + 'video/'
            if not os.path.exists(directory):
                os.makedirs(directory)
            location = directory + self.__privateData.test_name.replace(" ",
                                                                        "_") + "_" + datetime.now().strftime(
                "%H_%M_%S") + ".mp4"
            with open(location, 'wb') as f:
                f.write(base64.b64decode(video))
            self.__privateData.add_video(location)
        else:
            if auto_stop:
                return
            print("Nothing is recoding in " + self.__privateData.test_name)
