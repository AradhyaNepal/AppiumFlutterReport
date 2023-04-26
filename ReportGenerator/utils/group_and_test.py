from utils.report_generator import report_generator
from model.test_case import TestCaseData, Status
from utils.logger import Logger


def group(title: str, function_with_no_parameter, skip: bool = False):
    __create_test_case(title=title, testing=function_with_no_parameter, is_group=True, skip=skip)


def test(title: str, function_with_logger_as_parameter, skip: bool = False):
    __create_test_case(title=title, testing=function_with_logger_as_parameter, is_group=False, skip=skip)


def __create_test_case(title: str, testing, is_group: bool, skip: bool = False):
    parent_data = TestCaseData("", is_group=False)
    root_element_with_no_parent = False
    if len(report_generator.current_pointer) == 0:
        print("bookmark empty")
        root_element_with_no_parent = True
        report_generator.current_pointer.append(0)
    elif len(report_generator.current_pointer) == 1:
        print("bookmark empty root")
        root_element_with_no_parent = True
    else:
        print("bookmark branch")
        parent_pointer=[]
        for i in report_generator.current_pointer:
            parent_pointer.append(i)
        parent_pointer.pop()
        temp = report_generator.testCaseData
        for index in parent_pointer:
            temp = temp[index]
        print(temp)
        parent_data: TestCaseData = temp
        print(parent_data)
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
    print("\n")
    print(title)
    print(str(report_generator.current_pointer))


    if skip:
        test_case.test_completed("-", Status.SKIPPED)
    try:
        # Run The Testing

        if is_group:
            report_generator.current_pointer.append(0)
            testing()
            last_index=report_generator.current_pointer.pop()-1
            report_generator.current_pointer[last_index]=report_generator.current_pointer[last_index]+1

        else:
            logger = Logger(test_case)
            testing(logger)
            last_count = len(report_generator.current_pointer) - 1
            report_generator.current_pointer[last_count] = report_generator.current_pointer[last_count] + 1

    except AssertionError:
        test_case.test_completed("_", Status.FAILED)
    except Exception as e:
        test_case.test_completed(str(e), Status.ERROR)
    print(title+" Test Completed")



