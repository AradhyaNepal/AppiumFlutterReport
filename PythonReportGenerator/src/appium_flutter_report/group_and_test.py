import time

from .report_generator import FlutterReportGenerator
from .test_case import TestCaseData, Status
from .logger import Logger
import traceback
from datetime import datetime


def group(title: str, function_may_with_logger_as_parameter, skip: bool = False) -> bool:
    return __create_test_case(title=title, testing=function_may_with_logger_as_parameter, is_group=True,
                              skip=skip)


def test(title: str, function_may_with_logger_as_parameter, skip: bool = False) -> bool:
    return __create_test_case(title=title, testing=function_may_with_logger_as_parameter, is_group=False,
                              skip=skip)


# noinspection PyUnreachableCode
def __create_test_case(title: str, testing, is_group: bool, skip: bool = False) -> bool:
    parent_data = TestCaseData("", is_group=False)
    root_element_with_no_parent = False
    if len(FlutterReportGenerator.current_pointer) == 0:
        root_element_with_no_parent = True
        FlutterReportGenerator.current_pointer.append(0)
    elif len(FlutterReportGenerator.current_pointer) == 1:
        root_element_with_no_parent = True
    else:
        parent_pointer = []
        for i in FlutterReportGenerator.current_pointer:
            parent_pointer.append(i)
        parent_pointer.pop()
        # noinspection PyTypeChecker
        temp = FlutterReportGenerator.testCaseData
        parent_depth = 0
        for index in parent_pointer:
            if parent_depth == 0:
                temp = temp[index]
            else:
                temp: TestCaseData = temp
                temp = temp.children[index]
            parent_depth = parent_depth + 1
        parent_data: TestCaseData = temp
        if False:
            print("Bello")
            # Todo: Implement Inside Test Cannot be Group or Test
            # # Todo: Implement Skip
            # warning = "Warning: Group or Another Test '" + title + "' :cannot Be added inside Test, Skipped all the " \
            #                                                        "testing in " \
            #                                                        "particular Test scope"
            # print(warning)
            # parent_data.test_completed(
            #     warning,
            #     Status.FAILED, invalid_grouping=True)
            # # return
    test_case = TestCaseData(title, is_group=is_group)

    if root_element_with_no_parent:
        FlutterReportGenerator.testCaseData.append(test_case)
    else:
        parent_data.children.append(test_case)
    if skip:
        test_case.test_completed("-", Status.SKIPPED)
        return false
    logger = Logger(test_case)
    try:
        # Run The Testing
        if is_group:
            FlutterReportGenerator.current_pointer.append(0)
            try:
                testing(logger)
            except TypeError:
                testing()
        else:
            try:
                testing(logger)
            except TypeError:
                testing()
        test_case.test_completed("_", Status.SUCCESS)
        is_success = True
    except AssertionError:
        test_case.test_completed("_", Status.FAILED)
        logger.add_screenshot()
        is_success = False
    except Exception as e:
        print(str(e))
        print(traceback.format_exc())
        logger.add_step("Got Error!: " + str(e))
        logger.add_error(traceback.format_exc())
        logger.add_screenshot()
        test_case.test_completed(str(e), Status.ERROR)
        is_success = True
    logger.stop_and_save_recording(auto_stop=True)
    if is_group:
        FlutterReportGenerator.current_pointer.pop()
        last_index = len(FlutterReportGenerator.current_pointer) - 1
        FlutterReportGenerator.current_pointer[last_index] = FlutterReportGenerator.current_pointer[last_index] + 1
    else:
        last_index = len(FlutterReportGenerator.current_pointer) - 1
        FlutterReportGenerator.current_pointer[last_index] = FlutterReportGenerator.current_pointer[last_index] + 1
    return is_success
