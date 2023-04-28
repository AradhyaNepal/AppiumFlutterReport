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
    int removedValue = _removeSiblingsOfExpandedParentExceptRoot(
      parentLocation: expandedData.first.parentData!.parentIndexLocation,
      parentIndex: parentToBeExpanded.currentIndex,
    );
    _updateUIListWithNewExpandedChildList(
        parentToBeExpanded, expandedData, removedValue);
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
    final grandParentIndex = [...parentLocation].removeLast();
    bool reachedTillParent = false;
    for (int i = 0; i < testCaseWidgetList.length; i++) {
      if (testCaseWidgetList[i].parentData == null) {
        if (reachedTillParent) {
          break;
        } else {
          continue;
        }
      }

      if (!reachedTillParent &&
          testCaseWidgetList[i].currentIndex == parentIndex - itemsRemoved) {
        reachedTillParent = true;
        testCaseWidgetList[parentIndex - itemsRemoved].currentIndex =
            parentIndex - itemsRemoved;
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
      testCaseWidgetList[i].currentIndex =
          testCaseWidgetList[i].currentIndex - itemsRemoved;
    }
    return itemsRemoved;
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

  void _updateUIListWithNewExpandedChildList(TestCaseRowData testCaseRowData,
      List<TestCaseRowData> expandedData, int removedSiblings) {
    bool isNotFirst = testCaseRowData.currentIndex != 0;
    bool isNotLast =
        testCaseRowData.currentIndex != testCaseWidgetList.length - 1;
    testCaseWidgetList = [
      if (isNotFirst)
        ...testCaseWidgetList.sublist(0, testCaseRowData.currentIndex),
      ...expandedData,
      if (isNotLast)
        ...testCaseWidgetList
            .sublist(
                testCaseRowData.currentIndex + 1, testCaseWidgetList.length)
            .map((e) => e
              ..currentIndex =
                  e.currentIndex + expandedData.length - removedSiblings),
    ];
  }
}
