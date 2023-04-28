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
          parentData: null,
          currentIndex: i,
          isGroup: report.result[i].children != null,
        ),
      );
    }
  }

  void expandChildren(TestCaseRowData parentToBeExpanded) {
    if (parentToBeExpanded.testCase.children == null) return;
    List<TestCaseRowData> expandedData =
        _getExpandedChildList(parentToBeExpanded);
    _updateUIListWithNewExpandedChildList(parentToBeExpanded, expandedData);
    if (expandedData.first.parentData == null) return;
    _removeSiblingsOfExpandedParentExceptRoot(
      parentLocation: expandedData.first.parentData!.parentIndexLocation,
      childStartIndex: parentToBeExpanded.currentIndex,
      childEndIndex: parentToBeExpanded.currentIndex + expandedData.length,
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
  void _removeSiblingsOfExpandedParentExceptRoot({
    required int childStartIndex,
    required int childEndIndex,
    required List<int> parentLocation,
  }) {
    if (parentLocation.length < 2) return;
    final grandParentLocation = [...parentLocation].removeLast();
    int timesRemoved=0;
    for (var i = childStartIndex - 1; i >= 0; i--) {
      if(testCaseWidgetList[i].parentData==null)break;
      
      if(grandParentLocation.toString()==testCaseWidgetList[i].parentData?.parentIndexLocation.toString()){
        testCaseWidgetList.remove(value)
        continue;
      }else{
        break;
      }
    }
    if (childEndIndex + 1 >= testCaseWidgetList.length - 1) return;
    for (var i = childEndIndex + 1; i < testCaseWidgetList.length; i++) {
      //Remove
      break;
    }
  }

  List<TestCaseRowData> _getExpandedChildList(TestCaseRowData parentRowData) {
    List<TestCaseRowData> expandedData = [];
    final children = parentRowData.testCase.children ?? [];
    int parentIndex = parentRowData.currentIndex;
    for (int i = 0; i < children.length; i++) {
      ChildType childType = _getChildType(i, children);
      expandedData.add(
        TestCaseRowData(
          testCase: children[i],
          parentData:
              _getChildOpenedData(childType, parentRowData, parentIndex),
          currentIndex: parentIndex + i,
          isGroup: children[i].children != null,
        ),
      );
    }
    return expandedData;
  }

  ParentData _getChildOpenedData(
      ChildType childType, TestCaseRowData parentTestCase, int parentIndex) {
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

  ChildType _getChildType(int i, List<TestCase> children) {
    ChildType childType = ChildType.mid;
    if (i == 0) {
      childType = ChildType.first;
    } else if (i == children.length - 1) {
      childType = ChildType.last;
    }
    return childType;
  }

  void _updateUIListWithNewExpandedChildList(
      TestCaseRowData testCaseRowData, List<TestCaseRowData> expandedData) {
    bool isNotFirst = testCaseRowData.currentIndex != 0;
    bool isNotLast =
        testCaseRowData.currentIndex != testCaseWidgetList.length - 1;
    testCaseWidgetList = [
      if (isNotFirst)
        ...testCaseWidgetList.sublist(0, testCaseRowData.currentIndex),
      ...expandedData,
      if (isNotLast) ..._lastElement(testCaseRowData, expandedData.length),
    ];
  }

  Iterable<TestCaseRowData> _lastElement(
      TestCaseRowData testCaseRowData, int extraItemsAdded) {
    return testCaseWidgetList
        .sublist(testCaseRowData.currentIndex + 1, testCaseWidgetList.length)
        .map((e) => e..currentIndex = e.currentIndex + extraItemsAdded);
  }
}
