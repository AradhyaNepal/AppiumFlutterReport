import 'package:appium_report/model/report.dart';
import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';

class TestCaseDataController {
  List<TestCaseRowData> testCaseWidgetList = [];
  Report report;

  TestCaseDataController(this.report);

  void renderTableData() {
    testCaseWidgetList.clear();
    for (int i = 0; i < report.result.length; i++) {
      testCaseWidgetList.add(
        TestCaseRowData(
          actualPosition: [i],
          parentData: null,
          isGroup: report.result[i].children != null,
        ),
      );
    }
  }

  void expandChildren({
    required TestCaseRowData parentTestCase,
  }) {
    final actualParent =
        _getTestCaseFromActualPosition(parentTestCase.actualPosition);
    if (actualParent.children == null) return;
    if ((actualParent.children ?? []).isEmpty) return;

    List<TestCaseRowData> expandedData = _getExpandedChildList(
      parentRowData: parentTestCase,
      parentActualData: actualParent,
    );

    _removeSiblingsOfExpandedParentExceptRoot(
      actualParentLocation: parentTestCase.actualPosition,
    );

    _updateUIListWithNewExpandedChildList(
      parentTestCase: parentTestCase,
      expandedData: expandedData,
    );
  }

  /// Lets say Group1 have Group2 , Group 3 and Test 1 children.
  ///
  /// Group 2 is Expanded, now we need to show Group 2 Children.
  /// Here Group 2 is Parent of those new Children.
  ///
  /// This method removes Group 3 and Test 1, when Group 2 is expanded,
  /// aka removes Siblings of Group 2 when its expanded.
  ///
  /// But lets say Group 1 have also Sibling Group 0, but Group 1 and Group 0 are root (first depth)
  /// element of the family free which came from report.testCase.
  ///
  /// For root element, allow all the possible root element to be opened.
  ///
  /// After removing return how many items the code had removed
  void _removeSiblingsOfExpandedParentExceptRoot({
    required List<int> actualParentLocation,
  }) {
    if (actualParentLocation.length < 2) return;
    final grandParentIndex = [...actualParentLocation];
    grandParentIndex.removeLast();
    final String grandParentIndexString = grandParentIndex.toString();
    int parentUIIndex = _getParentIndex(actualParentLocation);
    _removeAfterParentData(parentUIIndex, grandParentIndexString);
    _removeBeforeParentData(parentUIIndex, grandParentIndexString);
  }

  void _removeAfterParentData(int parentUIIndex, String grandParentIndex) {
    if (parentUIIndex + 1 > testCaseWidgetList.length - 1) return;
    for (int i = parentUIIndex + 1; i < testCaseWidgetList.length; i++) {
      if (testCaseWidgetList[i].parentData == null) {
        break;
      }
      if (testCaseWidgetList[i].parentData?.actualParentLocation.toString() ==
          grandParentIndex) {
        testCaseWidgetList.removeAt(i);
      } else {
        break;
      }
    }
  }

  void _removeBeforeParentData(int parentUIIndex, String grandParentIndex) {
    int tillWhereGrandParentFound = parentUIIndex;
    for (int i = parentUIIndex - 1; i >= 0; i--) {
      if (testCaseWidgetList[i].parentData == null) {
        break;
      }
      if (testCaseWidgetList[i].parentData?.actualParentLocation.toString() ==
          grandParentIndex) {
        tillWhereGrandParentFound--;
      } else {
        break;
      }
    }

    if (tillWhereGrandParentFound < parentUIIndex) {
      testCaseWidgetList = [
        if (tillWhereGrandParentFound != 0)
          ...testCaseWidgetList.sublist(0, tillWhereGrandParentFound),
        if (parentUIIndex != testCaseWidgetList.length - 1)
          ...testCaseWidgetList.sublist(
              parentUIIndex, testCaseWidgetList.length),
      ];
    }
  }

  int _getParentIndex(List<int> actualParentLocation) {
    return testCaseWidgetList.indexWhere((element) =>
        element.actualPosition.toString() == actualParentLocation.toString());
  }

  List<TestCaseRowData> _getExpandedChildList({
    required TestCaseRowData parentRowData,
    required TestCase parentActualData,
  }) {
    List<TestCaseRowData> expandedData = [];
    final children = parentActualData.children ?? [];
    for (int i = 0; i < children.length; i++) {
      ChildType childType = _getChildType(i: i, children: children);
      expandedData.add(
        TestCaseRowData(
          parentData: ParentData(
            childType: childType,
            parents: [
              ...parentRowData.parentData?.parents ?? [],
              parentActualData.testName,
            ],
            actualParentLocation: parentRowData.actualPosition,
          ),
          isGroup: children[i].children != null,
          actualPosition: [...parentRowData.actualPosition, i],
        ),
      );
    }
    return expandedData;
  }

  TestCase _getTestCaseFromActualPosition(List<int> actualPosition) {
    dynamic value;
    for (var i in actualPosition) {
      value = report.result[i];
    }
    return value;
  }

  ChildType _getChildType({
    required int i,
    required List<TestCase> children,
  }) {
    ChildType childType = ChildType.mid;
    if (i == 0) {
      childType = ChildType.first;
    } else if (i == children.length - 1) {
      childType = ChildType.last;
    }
    return childType;
  }

  void _updateUIListWithNewExpandedChildList({
    required TestCaseRowData parentTestCase,
    required List<TestCaseRowData> expandedData,
  }) {
    bool isNotFirst = parentIndex != 0;
    bool isNotLast = parentIndex != testCaseWidgetList.length - 1;
    testCaseWidgetList = [
      if (isNotFirst) ...testCaseWidgetList.sublist(0, parentIndex),
      ...expandedData,
      if (isNotLast)
        ...testCaseWidgetList.sublist(
            parentIndex + 1, testCaseWidgetList.length),
    ];
  }

  void goBack(List<int> parentsIndex) {
    renderTableData();
    final grandParentIndex = [...parentsIndex];
    grandParentIndex.removeLast();
  }
}
