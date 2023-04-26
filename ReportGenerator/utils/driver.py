from imports import *
from appium import webdriver

capabilities=dict(
        platformName='Android',
        automationName='flutter',
        deviceName='emulator-5554',
        appPackage='com.mofin.oxpan_mofin',
        appActivity='.MainActivity',
        language='en',
        locale='US',
    )

url='http://localhost:4723'
driver = webdriver.Remote(url, capabilities)
