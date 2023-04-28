import 'package:appium_report/model/report.dart';
import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';

class TestCaseDataController {
  List<TestCaseRowData> testCaseWidgetList = [];

  void renderTableData(Report report) {
    for (int i = 0; i < report.result.length; i++) {
      testCaseWidgetList.add(
        TestCaseRowData(
          testCase: report.result[i],
          childOpenedData: null,
          currentIndex: i,
          isGroup: report.result[i].children != null,
        ),
      );
    }
  }

  void expandChildren(TestCaseRowData testCaseRowData) {
    if (testCaseRowData.testCase.children == null) return;
    List<TestCaseRowData> expandedData = _getExpandedChildList(testCaseRowData);
    _updateUIListWithNewExpandedData(testCaseRowData, expandedData);
  }

  List<TestCaseRowData> _getExpandedChildList(TestCaseRowData testCaseRowData) {
    List<TestCaseRowData> expandedData = [];
    final children = testCaseRowData.testCase.children ?? [];
    int parentIndex = testCaseRowData.currentIndex;
    for (int i = 0; i < children.length; i++) {
      ChildType childType = _getChildType(i, children);
      expandedData.add(
        TestCaseRowData(
          testCase: children[i],
          childOpenedData:
              _getChildOpenedData(childType, testCaseRowData, parentIndex),
          currentIndex: parentIndex + i,
          isGroup: children[i].children != null,
        ),
      );
    }
    return expandedData;
  }

  ChildOpenedData _getChildOpenedData(
      ChildType childType, TestCaseRowData testCaseRowData, int parentIndex) {
    return ChildOpenedData(
      childType: childType,
      parents: [
        ...testCaseRowData.childOpenedData?.parents ?? [],
        testCaseRowData.testCase.testName
      ],
      parentIndexLocation: [
        ...testCaseRowData.childOpenedData?.parentIndexLocation ?? [],
        parentIndex
      ],
    );
  }

  ChildType _getChildType(int i, List<TestCase> children) {
    ChildType childType = ChildType.mid;
    if (i == 0) {
      childType = ChildType.first;
    } else if (i == children.length - 1) {
      childType = ChildType.last;
    }
    return childType;
  }

  void _updateUIListWithNewExpandedData(
      TestCaseRowData testCaseRowData, List<TestCaseRowData> expandedData) {
    bool isNotFirst = testCaseRowData.currentIndex != 0;
    bool isNotLast =
        testCaseRowData.currentIndex != testCaseWidgetList.length - 1;
    testCaseWidgetList = [
      if (isNotFirst)
        ...testCaseWidgetList.sublist(0, testCaseRowData.currentIndex),
      ...expandedData,
      if (isNotLast)
        ...testCaseWidgetList.sublist(
            testCaseRowData.currentIndex + 1, testCaseWidgetList.length),
    ];
  }
}
