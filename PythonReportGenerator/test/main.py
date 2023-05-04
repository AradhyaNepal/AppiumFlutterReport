from crud.test_crud import test_crud
from login.test_login import test_login


def main():
    capabilities = dict(
        platformName='Android',
        automationName='flutter',
        deviceName='emulator-5554',
        appPackage='com.example.animation',
        appActivity='.MainActivity',
        language='en',
        locale='US',
    )
    driver = webdriver.Remote("http://localhost:4723", capabilities)
    FlutterReportGenerator.setup(
        driver=driver,
        app_name="Animation Test",
        capabilities=capabilities,
        report_path="../Output/",  # Todo:Set Report path as per your project, for my case Output is in .gitignore
    )
    test_login()
    test_crud()
    FlutterReportGenerator.generate_report()
    driver.quit()


if __name__ == "__main__":
    main()
