from report_generator import report_generator
from model.test_case import TestCaseData,Status
from logger import Logger


def group(title: str, testing: function, skip: bool = False):
    __create_test_case(title=title, testing=testing, is_group=True, skip=skip)


def test(title: str, testing: function(Logger), skip: bool = False):
    __create_test_case(title=title, testing=testing, is_group=False, skip=skip)


def __create_test_case(title: str, testing, is_group: bool, skip: bool = False):
    if report_generator.bookmark.count() is 0:
        report_generator.bookmark.append(0)

    temp = None
    for index in report_generator.bookmark:
        temp = parent_test_case[index]
    parent_data: TestCaseData = temp
    if parent_data.is_group is not True or parent_data.children is None:
        parent_data.test_completed("Group '" + title + "' :"
                                                       "cannot Be added inside Test, Skipped all the testing in particular test",
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
            logger=Logger(test_case)
            testing(logger)
    except AssertionError:
        test_case.test_completed("_", Status.FAILED)
    except e:
        test_case.test_completed(e, Status.ERROR)
    parent_data.children.append(test_case)
    last_index = report_generator.bookmark.pop()
    report_generator.bookmark[last_index - 1] = report_generator.bookmark[last_index - 1] + 1
