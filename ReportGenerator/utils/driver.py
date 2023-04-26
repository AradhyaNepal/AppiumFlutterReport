from imports import *
from appium import webdriver


class DriverSetup:
    report_path = ""
    url = 'http://localhost:4723'
    capabilities = dict(
        platformName='Android',
        automationName='flutter',
        deviceName='emulator-5554',
        appPackage='com.mofin.oxpan_mofin',
        appActivity='.MainActivity',
        language='en',
        locale='US',
    )

    driver: webdriver.Remote

    @staticmethod
    def setup():
        DriverSetup.driver = webdriver.Remote(DriverSetup.url, DriverSetup.capabilities)

    @staticmethod
    def close():
        DriverSetup.driver.quit()
