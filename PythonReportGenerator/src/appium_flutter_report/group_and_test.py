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
    if FlutterReportGenerator.inside_test is not None:
        test_type = ("Group" if is_group else "Test")
        print("WARNING: Only inside Group there could be another Test/Group.")
        print("But " + test_type + " Named:'" + title + "' was found inside Test named: '" + str(
            FlutterReportGenerator.inside_test) + "'.")
        print("This " + test_type + " is completely ignored.")
        return False
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
    test_case = TestCaseData(title, is_group=is_group)

    if root_element_with_no_parent:
        FlutterReportGenerator.testCaseData.append(test_case)
    else:
        parent_data.children.append(test_case)
    if skip:
        test_case.test_completed("Any sub children inside this group are ignored." if is_group else "-", Status.SKIPPED)
        return False
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
            FlutterReportGenerator.inside_test = test_case.test_name
            try:
                testing(logger)
            except TypeError:
                testing()
        test_case.test_completed("_", Status.SUCCESS)
        is_success = True
    except AssertionError:
        test_case.test_completed("_", Status.FAILED)
        logger.add_screenshot(is_error=True)
        is_success = False
    except Exception as e:
        print(str(e))
        print(traceback.format_exc())
        logger.add_step("Got Error!: " + str(e))
        logger.add_screenshot(is_error=True)
        test_case.test_completed(str(e) + "\n" + traceback.format_exc(), Status.ERROR)
        is_success = True
    FlutterReportGenerator.inside_test = None
    logger.stop_and_save_recording(auto_stop=True)
    if is_group:
        FlutterReportGenerator.current_pointer.pop()
        last_index = len(FlutterReportGenerator.current_pointer) - 1
        FlutterReportGenerator.current_pointer[last_index] = FlutterReportGenerator.current_pointer[last_index] + 1
    else:
        last_index = len(FlutterReportGenerator.current_pointer) - 1
        FlutterReportGenerator.current_pointer[last_index] = FlutterReportGenerator.current_pointer[last_index] + 1
    return is_success
