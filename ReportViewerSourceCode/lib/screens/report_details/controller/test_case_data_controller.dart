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
          testCase: report.result[i],
        ),
      );
    }
  }

  void expandChildren({
    required TestCaseRowData parentTestCase,
  }) {
    if (parentTestCase.testCase.children == null) return;
    if ((parentTestCase.testCase.children ?? []).isEmpty) return;

    List<TestCaseRowData> expandedData = _getExpandedChildList(
      parentRowData: parentTestCase,
      parentActualData: parentTestCase.testCase,
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
      ChildType childType =
          _getChildType(i: i, familyMembersLength: children.length);
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
          testCase: children[i],
        ),
      );
    }
    return expandedData;
  }

  ChildType _getChildType({
    required int i,
    required int familyMembersLength,
  }) {
    ChildType childType = ChildType.mid;
    if (i == 0) {
      childType = ChildType.first;
    } else if (i == familyMembersLength - 1) {
      childType = ChildType.last;
    }
    return childType;
  }

  void _updateUIListWithNewExpandedChildList({
    required TestCaseRowData parentTestCase,
    required List<TestCaseRowData> expandedData,
  }) {
    int parentIndex = _getParentIndex(parentTestCase.actualPosition);
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

  ///Every children have its parentsActualLocation,
  ///
  /// Say Group 1 have Children Test 1 and Group 2.
  ///
  /// And Group 2 have Children Test 2 and Test 3.
  ///
  /// And Group 2 is expanded, so Parent Data for Test 2 is (0,1)
  ///
  /// whichParentIndex index 0 means (0,1)'s index 0 aka Grand Parent of Test 2
  /// and whichParentIndex index 1 means (0,1)'s index 1 aka Parent of Test 2
  ///
  /// But whichParentIndex is 1 aka Parent, its already opened, so it will perform no effect
  ///
  /// Assume: () bracket denotes List bracket for this documentation
  void goBack(List<int> parentsActualLocation, int whichParentIndex) {
    if (whichParentIndex == parentsActualLocation.length - 1) return;
    renderTableData();
    final newParentLocation =
        parentsActualLocation.sublist(0, whichParentIndex + 1);
    var elementToBeExpanded = testCaseWidgetList[newParentLocation.first];
    for (int whichParentLocalLoop = 0;
        whichParentLocalLoop < newParentLocation.length;
        whichParentLocalLoop++) {
      final elementToBeExpandedLocal = elementToBeExpanded.copyWith();
      expandChildren(parentTestCase: elementToBeExpandedLocal);

      int nextLoopIndex = whichParentLocalLoop + 1;
      if (nextLoopIndex < newParentLocation.length) {
        final nextElementTestCase = (elementToBeExpanded.testCase.children ??
            [])[newParentLocation[nextLoopIndex]];
        elementToBeExpanded = TestCaseRowData(
          parentData: ParentData(
            childType: _getChildType(
                i: newParentLocation[nextLoopIndex],
                familyMembersLength:
                    (elementToBeExpanded.testCase.children ?? []).length),
            parents: [
              if (whichParentLocalLoop == 0)
                elementToBeExpanded.testCase.testName
              else ...[
                ...elementToBeExpanded.parentData!.parents,
                elementToBeExpanded.testCase.testName
              ]
            ],
            actualParentLocation: elementToBeExpanded.actualPosition,
          ),
          isGroup: nextElementTestCase.children != null,
          testCase: nextElementTestCase,
          actualPosition: [
            ...elementToBeExpanded.actualPosition,
            newParentLocation[nextLoopIndex],
          ],
        );
      }
    }
  }
}
