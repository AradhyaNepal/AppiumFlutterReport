from imports import *
from appium import webdriver


__driver = webdriver.Remote('http://localhost:4723', dict(
        platformName='Android',
        automationName='flutter',
        deviceName='emulator-5554',
        appPackage='com.mofin.oxpan_mofin',
        appActivity='.MainActivity',
        language='en',
        locale='US',
    ))


def driver() -> webdriver.Remote:
    return __driver


if __name__ == "__main__":
    main()
