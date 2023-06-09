import time

from src.appium_flutter_report import group, test
from src.appium_flutter_report.logger import Logger



def test_login():
    value=group(
        "Testing Login",
        group_login,
    )
    print("Login "+str(value))


def group_login(logger:Logger):
    logger.add_screenshot()
    value=test(
        "Wrong Login",
        wrong_login,
    )
    print("Wrong "+str(value))
    value=test(
        "Correct Login",
        correct_login,
    )
    print("Correct " + str(value))


def correct_login(logger: Logger):
    logger.add_step("Username: 9800915400 Password: Correct Password")
    logger.add_step("Login Button Pressed")
    assert False


def wrong_login(logger: Logger):
    logger.add_step("Username: 9800915400 Password: Wrong Password")
    logger.add_step("Login Button Pressed")
    assert True
