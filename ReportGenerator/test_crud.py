import allure
import pytest
from driver import driver
from group_and_test import group, test
from logger import Logger


def test_crud():
    group(
        "Testing CRUD",
        group_crud
    )


def group_crud():
    group(
        "Create",
        group_create
    )
    test(
        "Testing Read",
        read,
    )
    group(
        "Update",
        group_update
    )
    test(
        "Testing Delete",
        delete,
    )


def read(logger: Logger):
    logger.add_step("Read Button Was Pressed")
    logger.add_step("Yes I want to read it any how was pressed")
    assert False


def delete(logger: Logger):
    logger.add_step("Delete Button Was Pressed")
    logger.add_step("Confirm To Delete Was Pressed")
    assert True


def group_create():
    create_correct()
    create_wrong()


def create_correct():
    logger.add_step("Correct Info Was Added")
    logger.add_step("Create Button Is Pressed")
    assert False


def create_wrong():
    logger.add_step("Wrong Info Was Added")
    logger.add_step("Create Button Is Pressed")
    assert True


def group_update():
    update_correct()
    update_wrong()


def update_correct():
    logger.add_step("Correct Info Was Added")
    logger.add_step("Update Button Is Pressed")
    assert True


def update_wrong():
    logger.add_step("Wrong Info Was Added")
    logger.add_step("Update Button Is Pressed")
    assert False
