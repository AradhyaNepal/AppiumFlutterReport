from src.appium_flutter_report.report_generator import FlutterReportGenerator
from src.appium_flutter_report.test_case import TestCaseData, Status
from src.appium_flutter_report.logger import Logger
import traceback


def group(title: str, function_with_no_parameter, skip: bool = False):
    __create_test_case(title=title, testing=function_with_no_parameter, is_group=True,
                       skip=skip)


def test(title: str, function_with_logger_as_parameter, skip: bool = False):
    __create_test_case(title=title, testing=function_with_logger_as_parameter, is_group=False,
                       skip=skip)


def __create_test_case(title: str, testing, is_group: bool, skip: bool = False):
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
            # Todo: Implement Inside Test Cannot be Group or Test
            # Todo: Implement Skip
            warning = "Warning: Group or Another Test '" + title + "' :cannot Be added inside Test, Skipped all the " \
                                                                   "testing in " \
                                                                   "particular Test scope"
            print(warning)
            parent_data.test_completed(
                warning,
                Status.FAILED, invalid_grouping=True)
            # return
    test_case = TestCaseData(title, is_group=is_group)
    if root_element_with_no_parent:
        FlutterReportGenerator.testCaseData.append(test_case)
    else:
        parent_data.children.append(test_case)
    if skip:
        test_case.test_completed("-", Status.SKIPPED)
        return
    try:
        # Run The Testing
        if is_group:
            FlutterReportGenerator.current_pointer.append(0)
            testing()
        else:
            logger = Logger(test_case)
            testing(logger)
        test_case.test_completed("_", Status.SUCCESS)
    except AssertionError:
        test_case.test_completed("_", Status.FAILED)
    except Exception as e:
        print(str(e))
        print(traceback.format_exc())
        test_case.test_completed(str(e), Status.ERROR)
    if is_group:
        FlutterReportGenerator.current_pointer.pop()
        last_index = len(FlutterReportGenerator.current_pointer) - 1
        FlutterReportGenerator.current_pointer[last_index] = FlutterReportGenerator.current_pointer[last_index] + 1
    else:
        last_index = len(FlutterReportGenerator.current_pointer) - 1
        FlutterReportGenerator.current_pointer[last_index] = FlutterReportGenerator.current_pointer[last_index] + 1
