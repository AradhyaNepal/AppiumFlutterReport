from imports import *
from appium import webdriver


def main():
    driver = webdriver.Remote('http://localhost:4723', dict(
        platformName='Android',
        automationName='flutter',
        deviceName='emulator-5554',
        appPackage='com.mofin.oxpan_mofin',
        appActivity='.MainActivity',
        language='en',
        locale='US',
    ))


    report = '''<html>
    <head>
    <title>HTML File</title>
    </head> 
    <body>'''
    report = report+safe_test(test_one, "Test 1",driver)
    report = report+safe_test(test_two, "Test 2",driver)
    report = report+safe_test(test_three, "Test 3",driver)
    report = report+'''</body>
            </html>'''
    file_html = open("demo.html", "w")
    file_html.write(report)
    file_html.close()
    driver.quit()


if __name__ == "__main__":
    main()
