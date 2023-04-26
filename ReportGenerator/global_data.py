from report_generator import FlutterReportGenerator
from capabilities_and_url import *
from appium import webdriver


class Global:
    report_generator = FlutterReportGenerator(capabilities)
    driver = webdriver.Remote(url, capabilities)
