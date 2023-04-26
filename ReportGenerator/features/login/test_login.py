from utils.group_and_test import group, test
from utils.logger import Logger


def test_login():
    group(
        "Testing Login",
        group_login,
    )


def group_login():
    test(
        "Wrong Login",
        wrong_login,
    )
    test(
        "Correct Login",
        correct_login,
    )


def correct_login(logger: Logger):
    logger.add_step("Username: 9800915400 Password: Correct Password")
    logger.add_step("Login Button Pressed")
    assert False


def wrong_login(logger: Logger):
    logger.add_step("Username: 9800915400 Password: Wrong Password")
    logger.add_step("Login Button Pressed")
    assert True
