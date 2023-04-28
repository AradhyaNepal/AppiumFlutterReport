import 'package:appium_report/model/report.dart';
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
    int parentIndex = testCaseRowData.currentIndex;
    List<TestCaseRowData> expandedData = [];
    if (testCaseRowData.testCase.children == null) return;
    final children = testCaseRowData.testCase.children ?? [];
    for (int i = 0; i < children.length; i++) {
      ChildType childType = ChildType.mid;
      if (i == 0) {
        childType = ChildType.first;
      } else if (i == children.length - 1) {
        childType = ChildType.last;
      }
      expandedData.add(
        TestCaseRowData(
          testCase: children[i],
          childOpenedData: ChildOpenedData(
            childType: childType,
            parents: [
              ...testCaseRowData.childOpenedData?.parents ?? [],
              testCaseRowData.testCase.testName
            ],
            parentIndexLocation: [
              ...testCaseRowData.childOpenedData?.parentIndexLocation ?? [],
              parentIndex
            ],
          ),
          currentIndex: parentIndex + i,
          isGroup: children[i].children != null,
        ),
      );
    }
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
