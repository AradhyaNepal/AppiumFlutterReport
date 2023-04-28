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
          testCase: report.result[i],
          parentData: null,
          isGroup: report.result[i].children != null,
        ),
      );
    }
  }

  void expandChildren({
    required TestCaseRowData parentToBeExpanded,
    required int parentIndexOnUI,
  }) {
    if (parentToBeExpanded.testCase.children == null) return;
    List<TestCaseRowData> expandedData = _getExpandedChildList(
        parentRowData: parentToBeExpanded, parentIndex: parentIndexOnUI);
    int removedSiblings = _removeSiblingsOfExpandedParentExceptRoot(
      parentLocation: expandedData.first.parentData!.parentIndexLocation,
      parentIndex: parentIndexOnUI,
    );
    parentIndexOnUI = parentIndexOnUI - removedSiblings;
    _updateUIListWithNewExpandedChildList(
      parentTestCase: parentToBeExpanded,
      expandedData: expandedData,
      removedSiblings: removedSiblings,
      parentIndex: parentIndexOnUI,
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
  int _removeSiblingsOfExpandedParentExceptRoot({
    required List<int> parentLocation,
    required int parentIndex,
  }) {
    int itemsRemoved = 0;
    if (parentLocation.length <= 2) return itemsRemoved;
    final grandParentIndex = [...parentLocation];
    grandParentIndex.removeLast();
    bool reachedTillParent = false;
    for (int i = 0; i < testCaseWidgetList.length; i++) {
      if (testCaseWidgetList[i].parentData == null) {
        if (reachedTillParent) {
          break;
        } else {
          continue;
        }
      }

      if (!reachedTillParent && i == parentIndex - itemsRemoved) {
        reachedTillParent = true;
        continue;
      }
      if (testCaseWidgetList[i].parentData?.parentIndexLocation.toString() ==
          grandParentIndex.toString()) {
        itemsRemoved++;
        testCaseWidgetList.removeAt(i);
      } else if (reachedTillParent) {
        break;
      }
    }
    for (int i = parentIndex - itemsRemoved + 1;
        i < testCaseWidgetList.length;
        i++) {
      if ((parentIndex - itemsRemoved) < 0) continue;
    }
    return itemsRemoved;
  }

  List<TestCaseRowData> _getExpandedChildList({
    required TestCaseRowData parentRowData,
    required int parentIndex,
  }) {
    List<TestCaseRowData> expandedData = [];
    final children = parentRowData.testCase.children ?? [];
    for (int i = 0; i < children.length; i++) {
      ChildType childType = _getChildType(i: i, children: children);
      expandedData.add(
        TestCaseRowData(
          testCase: children[i],
          parentData: _getChildOpenedData(
              childType: childType,
              parentTestCase: parentRowData,
              parentIndex: parentIndex),
          isGroup: children[i].children != null,
        ),
      );
    }
    return expandedData;
  }

  ParentData _getChildOpenedData(
      {required ChildType childType,
      required TestCaseRowData parentTestCase,
      required int parentIndex}) {
    return ParentData(
      childType: childType,
      parents: [
        ...parentTestCase.parentData?.parents ?? [],
        parentTestCase.testCase.testName,
      ],
      parentIndexLocation: [
        ...parentTestCase.parentData?.parentIndexLocation ?? [],
        parentIndex
      ],
    );
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
    required int removedSiblings,
    required int parentIndex,
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

    //TOdo: This below code is risky
    for (var index in grandParentIndex) {
      expandChildren(
        parentToBeExpanded: testCaseWidgetList[index],
        parentIndexOnUI: index,
      );
    }
  }
}
