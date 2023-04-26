from utils.report_generator import report_generator
from model.test_case import TestCaseData, Status
from utils.logger import Logger
import traceback


def group(title: str, function_with_no_parameter, skip: bool = False):
    __create_test_case(title=title, testing=function_with_no_parameter, is_group=True, skip=skip)


def test(title: str, function_with_logger_as_parameter, skip: bool = False):
    __create_test_case(title=title, testing=function_with_logger_as_parameter, is_group=False, skip=skip)


def __create_test_case(title: str, testing, is_group: bool, skip: bool = False):
    print("\n")
    parent_data = TestCaseData("", is_group=False)
    root_element_with_no_parent = False
    if len(report_generator.current_pointer) == 0:
        root_element_with_no_parent = True
        report_generator.current_pointer.append(0)
    elif len(report_generator.current_pointer) == 1:
        root_element_with_no_parent = True
    else:
        parent_pointer = []
        for i in report_generator.current_pointer:
            parent_pointer.append(i)
        parent_pointer.pop()
        temp = report_generator.testCaseData
        parent_depth = 0
        for index in parent_pointer:
            if parent_depth == 0:
                temp = temp[index]
            else:
                temp: TestCaseData = temp
                temp = temp.children[index]
            parent_depth = parent_depth + 1
        parent_data: TestCaseData = temp
        if parent_data.is_group is not True or parent_data.children is None:
            parent_data.test_completed(
                "Group '" + title + "' :cannot Be added inside Test, Skipped all the testing in particular Test scope",
                Status.FAILED, invalid_grouping=True)
            return

    test_case = TestCaseData(title, is_group=is_group)
    if root_element_with_no_parent:
        report_generator.testCaseData.append(test_case)
    else:
        parent_data.children.append(test_case)
    print(title)
    print(str(report_generator.current_pointer))

    if skip:
        test_case.test_completed("-", Status.SKIPPED)
    try:
        # Run The Testing

        if is_group:
            report_generator.current_pointer.append(0)
            testing()
        else:
            logger = Logger(test_case)
            testing(logger)
    except AssertionError:
        test_case.test_completed("_", Status.FAILED)
    except Exception as e:
        print(str(e))
        print(traceback.format_exc())
        test_case.test_completed(str(e), Status.ERROR)
    finally:
        if is_group:
            last_index = report_generator.current_pointer.pop() - 1
            report_generator.current_pointer[last_index] = report_generator.current_pointer[last_index] + 1
        else:
            last_index = len(report_generator.current_pointer) - 1
            report_generator.current_pointer[last_index] = report_generator.current_pointer[last_index] + 1

    print(title + " Test Completed. Now Next" + str(report_generator.current_pointer))
