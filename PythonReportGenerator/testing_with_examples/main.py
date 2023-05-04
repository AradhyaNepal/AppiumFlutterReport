from imports import *
from crud.test_crud import test_crud
from login.test_login import test_login


def main():
    driver = webdriver.Remote(DriverSetup.url, DriverSetup.capabilities)
    FlutterReportGenerator.setup(
        driver=driver,
        app_name="Animation Test",
        capabilities=dict(
            platformName='Android',
            automationName='flutter',
            deviceName='emulator-5554',
            appPackage='com.example.animation',
            appActivity='.MainActivity',
            language='en',
            locale='US',
        ),
        report_path="",
    )
    test_login()
    test_crud()
    FlutterReportGenerator.generate_report()
    driver.quit()


if __name__ == "__main__":
    main()
