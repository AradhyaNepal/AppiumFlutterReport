import time

from src.appium_flutter_report import group, test
from src.appium_flutter_report.logger import Logger


def test_crud():
    group(
        "Testing CRUD",
        group_crud
    )


def group_crud():
    group(
        "Create",
        group_create,
    )
    test(
        "Testing Read",
        read,
    )
    group(
        "Update",
        group_update,
        skip=True
    )
    test(
        "Testing Delete",
        delete,
        skip=True
    )


def read(logger: Logger):
    group(
        "Delete: Must Throw test must not be inside test",
        delete2,
    )
    logger.add_step("Read Button Was Pressed")
    logger.add_step("Yes I want to read it any how was pressed")
    assert False


def delete(logger: Logger):
    logger.add_step("Delete Button Was Pressed")
    logger.add_step("Confirm To Delete Was Pressed")
    assert True

def delete2():
    assert True


def group_create():
    test(
        "Create Correct",
        create_correct,
    )
    test(
        "Create Wrong",
        create_wrong,
    )


def create_correct(logger:Logger):
    logger.add_step("Correct Info Was Added")
    logger.add_step("Create Button Is Pressed")
    assert False


def create_wrong(logger:Logger):
    logger.add_step("Wrong Info Was Added")
    logger.add_step("Create Button Is Pressed")
    assert True


def group_update():
    test(
        "Update Correct",
        update_correct,
    )
    test(
        "Update Wrong",
        update_wrong,
    )


def update_correct(logger:Logger):
    time.sleep(0.5)
    logger.add_step("Correct Info Was Added")
    logger.add_step("Update Button Is Pressed")
    assert True


def update_wrong(logger:Logger):
    # group("hello",testABC)
    logger.add_step("Wrong Info Was Added")
    logger.add_step("Update Button Is Pressed")
    assert False

def testABC():
    print("test")
