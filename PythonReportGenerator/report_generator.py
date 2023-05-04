from datetime import datetime
from test_case import TestCaseData
import json
from appium import webdriver


class FlutterReportGenerator:
    driver: webdriver.Remote
    app_name: str
    report_path: str
    capabilities: dict
    time: datetime
    testCaseData: list
    current_pointer: list

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

        # For now no screenshots
        file_name = FlutterReportGenerator.app_name + "_" + FlutterReportGenerator.time.strftime(
            "%y_%m_%d_%H_%M_%S") + ".json"
        file_name = file_name.replace(" ", "_")
        file = open(FlutterReportGenerator.report_path + file_name, "a")
        file.write(json.dumps(response, default=str), )
        file.close()

    @staticmethod
    def __get_result():
        result = []
        print(len(FlutterReportGenerator.testCaseData))
        for item in FlutterReportGenerator.testCaseData:
            item: TestCaseData = item
            result.append(item.to_json())
        return result
