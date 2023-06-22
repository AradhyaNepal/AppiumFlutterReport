from .test_case import TestCaseData
from .report_generator import FlutterReportGenerator
from .video import Video
from appium import webdriver
from datetime import datetime
import os
import base64


# Logger is available to user. It ensure that user can add details to TestCaseData's Object
# Yet Logger ensure that user cannot modify sensitive data from TestCaseData's Object
class Logger:
    def __init__(self, data: TestCaseData):
        self.__privateData = data
        self.is_recording_thumbnail = None

    def add_step(self, step: str):
        self.__privateData.add_step(step)

    def add_error(self, step: str):
        self.__privateData.add_error(step)

    def add_warning(self, warning: str):
        self.__privateData.add_warning(warning)

    def add_screenshot(self, is_error: bool = False):
        relative_folder_location = '/screenshot/'
        actual_folder_location = FlutterReportGenerator.get_actual_folder_location() + relative_folder_location
        file_name = ("Error_" if is_error else "") + self.__privateData.test_name.replace(
            " ",
            "_") + "_" + datetime.now().strftime(
            "%d_%m_%Y") + ".png"
        actual_file_location = actual_folder_location + file_name
        relative_file_location = relative_folder_location + file_name

        if not os.path.exists(actual_folder_location):
            os.makedirs(actual_folder_location)
            # TODO: Error or not on naming
        driver: webdriver.Remote = FlutterReportGenerator.driver
        print("Taking Screenshot")
        image = driver.get_screenshot_as_png()
        with open(actual_file_location, 'wb') as f:
            f.write(image)

        self.__privateData.add_screenshot(relative_file_location)

    def start_recording(self):
        if self.is_recording_thumbnail is None:
            print("Recording Started: "+self.__privateData.test_name)
            driver: webdriver.Remote = FlutterReportGenerator.driver
            driver.switch_to.context("NATIVE_APP")
            driver.start_recording_screen()
            driver.switch_to.context("FLUTTER")  # Todo: Context might already be NATIVE_APP
            self.is_recording_thumbnail = self.__add_video_thumbnail(driver)
        else:
            print("Already recording, cannot record " + self.__privateData.test_name)

    def __add_video_thumbnail(self, driver: webdriver.Remote) -> str:
        relative_folder_location = '/video/thumbnail/'
        actual_folder_location = FlutterReportGenerator.get_actual_folder_location() + relative_folder_location
        file_name = self.__privateData.test_name.replace(
            " ",
            "_") + "_" + datetime.now().strftime(
            "%d_%m_%Y") + ".png"
        actual_file_location = actual_folder_location + file_name
        relative_file_location = relative_folder_location + file_name
        image = driver.get_screenshot_as_png()
        if not os.path.exists(actual_folder_location):
            os.makedirs(actual_folder_location)
        with open(actual_file_location, 'wb') as f:
            f.write(image)
        return relative_file_location

    def stop_and_save_recording(self, auto_stop: bool = False):
        if self.is_recording_thumbnail is not None:
            driver: webdriver.Remote = FlutterReportGenerator.driver
            print("Recording Stopped: "+self.__privateData.test_name)
            driver.switch_to.context("NATIVE_APP")
            video = driver.stop_recording_screen()
            driver.switch_to.context("FLUTTER")  # Todo: Context might already be NATIVE_APP
            relative_folder_location = '/video/'
            actual_folder_location = FlutterReportGenerator.get_actual_folder_location() + relative_folder_location
            if not os.path.exists(actual_folder_location):
                os.makedirs(actual_folder_location)
            file_name = self.__privateData.test_name.replace(" ",
                                                             "_") + "_" + datetime.now().strftime(
                "%H_%M_%S") + ".mp4"
            actual_file_location = actual_folder_location + file_name
            relative_file_location = relative_folder_location + file_name
            with open(actual_file_location, 'wb') as f:
                f.write(base64.b64decode(video))
            self.__privateData.add_video(
                Video(video_location=relative_file_location, thumbnail_location=self.is_recording_thumbnail, ), )
            self.is_recording_thumbnail = None
        else:
            if auto_stop:
                return
            print("Nothing is recoding in " + self.__privateData.test_name)
