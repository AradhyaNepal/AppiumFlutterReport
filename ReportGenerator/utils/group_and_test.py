from report_generator import report_generator
from model.test_case import TestCaseData, Status
from logger import Logger


def group(title: str, function_with_no_parameter, skip: bool = False):
    __create_test_case(title=title, testing=function_with_no_parameter, is_group=True, skip=skip)


def test(title: str, function_with_logger_as_parameter, skip: bool = False):
    __create_test_case(title=title, testing=function_with_logger_as_parameter, is_group=False, skip=skip)
    list(filter(lambda x: x % 2 == 0, numbers))


def __create_test_case(title: str, testing, is_group: bool, skip: bool = False):
    if len(report_generator.bookmark) is False:
        report_generator.bookmark.append(0)

    temp = None
    for index in report_generator.bookmark:
        temp = parent_test_case[index]
    parent_data: TestCaseData = temp
    if parent_data.is_group is not True or parent_data.children is None:
        parent_data.test_completed(
            "Group '" + title + "' :cannot Be added inside Test, Skipped all the testing in particular Test scope",
            Status.FAILED, invalid_grouping=True)
        return
    test_case = TestCaseData(title, is_group=True)
    report_generator.bookmark.append(0)

    if skip:
        test_case.test_completed("-", Status.SKIPPED)
    try:
        # Run The Testing
        if is_group:
            testing()
        else:
            logger = Logger(test_case)
            testing(logger)
    except AssertionError:
        test_case.test_completed("_", Status.FAILED)
    except Exception as e:
        test_case.test_completed(str(e), Status.ERROR)
    parent_data.children.append(test_case)
    last_index = report_generator.bookmark.pop()
    report_generator.bookmark[last_index - 1] = report_generator.bookmark[last_index - 1] + 1
