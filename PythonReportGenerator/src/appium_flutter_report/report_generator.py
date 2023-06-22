from datetime import datetime
from .test_case import TestCaseData
import json
from appium import webdriver
import os


class FlutterReportGenerator:
    driver: webdriver.Remote
    app_name: str
    report_path: str
    capabilities: dict
    time: datetime
    testCaseData: list
    current_pointer: list
    inside_test: str

    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(FlutterReportGenerator, cls).__new__(cls)
        return cls.instance

    @staticmethod
    def setup(driver, app_name, report_path, capabilities):
        FlutterReportGenerator.driver = driver
        FlutterReportGenerator.app_name = app_name
        FlutterReportGenerator.report_path = report_path
        FlutterReportGenerator.capabilities = capabilities
        FlutterReportGenerator.time = datetime.now()
        FlutterReportGenerator.testCaseData = []
        FlutterReportGenerator.current_pointer = []
        FlutterReportGenerator.inside_test = None

    @staticmethod
    def generate_report():
        report_generator_start = datetime.now()
        response = {
            "time": FlutterReportGenerator.time,
            "appName": FlutterReportGenerator.app_name,
            "capabilities": FlutterReportGenerator.capabilities,
            "result": FlutterReportGenerator.__get_result()
        }
        report_generation_time = datetime.now() - report_generator_start
        duration = datetime.now() - FlutterReportGenerator.time
        response["duration"] = str(duration.total_seconds() * 1000) + " ms"
        response["generatingReportTime"] = str(report_generation_time.total_seconds() * 1000) + " ms"

        actual_folder_location = FlutterReportGenerator.get_actual_folder_location()
        if not os.path.exists(actual_folder_location):
            os.makedirs(actual_folder_location)
        actual_file_location = actual_folder_location + "/report.json"
        with open(actual_file_location, 'a') as f:
            f.write(json.dumps(response, default=str))

    @staticmethod
    def get_relative_folder_name() -> str:
        return FlutterReportGenerator.app_name.replace(" ", "") + "_" + FlutterReportGenerator.time.strftime(
            "%y%m%d%H%M%S")

    @staticmethod
    def get_actual_folder_location() -> str:
        return FlutterReportGenerator.report_path + FlutterReportGenerator.get_relative_folder_name()

    @staticmethod
    def __get_result():
        result = []
        print(len(FlutterReportGenerator.testCaseData))
        for item in FlutterReportGenerator.testCaseData:
            item: TestCaseData = item
            result.append(item.to_json())
        return result
