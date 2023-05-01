import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TestCaseDataController with ChangeNotifier {
  List<TestCaseRow> rowList = [];

  final List<TestCase> _originalTestCase;

  TestCaseDataController(this._originalTestCase) {
    _renderFirstRoot();
  }

  void expandChildren({
    required TestCaseRow parentTestCase,
    bool removeSiblingsAndRemoveParent = true,
  }) {
    if (parentTestCase.testCase.children == null) return;
    if ((parentTestCase.testCase.children ?? []).isEmpty) return;

    List<TestCaseRow> expandedData = _getExpandedChildList(
      parentRowData: parentTestCase,
      parentActualData: parentTestCase.testCase,
    );

    if (removeSiblingsAndRemoveParent) {
      _removeSiblingsOfExpandedParentExceptRoot(
        actualParentLocation: parentTestCase.actualPosition,
      );
    }
    _updateUIListWithNewExpandedChildList(
      parentTestCase: parentTestCase,
      expandedData: expandedData,
      preserveSelf: !removeSiblingsAndRemoveParent,
    );
    notifyListeners();
  }

  void goBack({
    required List<int> nearestParentPosition,
    required int targetedParentDepth,
  }) {
    if (nearestParentPosition.length == targetedParentDepth) return;//We are expanding same expanded group
    final targetedGroupLocation =
        nearestParentPosition.sublist(0, targetedParentDepth);
    bool forMinimizingTheRootGroup = _setupForRootGroupMinimizing(
        targetedGroupLocation: targetedGroupLocation,
        nearestParentPosition: nearestParentPosition,
        targetedParentDepth: targetedParentDepth);
    final targetedGroupRow =
        _removeChildAndAddTargetedParent(targetedGroupLocation);
    _checkAndExpandTargetedGroup(
      targetedGroupRow: targetedGroupRow,
      forMinimizingTheRootGroup: forMinimizingTheRootGroup,
    );
    notifyListeners();
  }

  ///Returns whether the purpose of going back is to minimize the root group, using back button.
  ///
  /// Also in setup, if increase the targetedGroupLocation value to root group from which its minimizing
  ///
  /// So after this step we are supposed to remove that minimizing root's children and add the rood group.
  ///
  /// And we need to make sure that we are not expanding root group, because we are here to minimize it.
  bool _setupForRootGroupMinimizing({
    required List<int> targetedGroupLocation,
    required List<int> nearestParentPosition,
    required int targetedParentDepth,
  }) {
    bool forMinimizingTheRootGroup = targetedGroupLocation.isEmpty;
    if (forMinimizingTheRootGroup) {
      targetedGroupLocation.add(nearestParentPosition[targetedParentDepth + 1]);
    }
    return forMinimizingTheRootGroup;
  }

  void _checkAndExpandTargetedGroup({
    required TestCaseRow? targetedGroupRow,
    required bool forMinimizingTheRootGroup,
  }) {
    if (forMinimizingTheRootGroup) return;
    if (targetedGroupRow == null) {
      if (kDebugMode) {
        print("Cannot find Targeted Parent");
      }
      return;
    }
    expandChildren(parentTestCase: targetedGroupRow);
  }

  TestCaseRow? _removeChildAndAddTargetedParent(
      List<int> targetedGroupLocation) {
    int? removeStart, removeEnd;
    TestCaseRow? targetedParentRow;
    for (int i = 0; i < rowList.length; i++) {
      final parentData = rowList[i].parentData;
      if (parentData == null) continue;
      final parentRow = parentData.actualParent;
      bool elementHaveGeneOfTargetedParent = parentRow.actualPosition
              .sublist(0, targetedGroupLocation.length)
              .toString() ==
          targetedGroupLocation.toString();
      if (elementHaveGeneOfTargetedParent) {
        removeStart ??= i;
        removeEnd = i;
        targetedParentRow = _extractTargetedRow(
            targetedParentRow, parentRow, targetedGroupLocation);
      } else if (removeStart != null) {
        //  The items are stored in a sequence so,
        // Once we had found starting of removal and no more element starts to be found
        // Then there will not be any element next
        break;
      }
    }

    if (removeStart == null || removeEnd == null || targetedParentRow == null)
      return null;

    //Removes Child
    rowList.removeRange(removeStart, removeEnd + 1);

    //Inside the first removed child index, adds the parent
    rowList.insert(removeStart, targetedParentRow);
    return targetedParentRow;
  }

  ///Extract only if its not already extracted
  TestCaseRow? _extractTargetedRow(TestCaseRow? targetedParentRowToExtract,
      TestCaseRow loopParentRow, List<int> targetedParentLocation) {
    if (targetedParentRowToExtract == null &&
        loopParentRow.actualPosition.toString() ==
            targetedParentLocation.toString()) {
      targetedParentRowToExtract = loopParentRow;
    }
    return targetedParentRowToExtract;
  }

  void _renderFirstRoot() {
    rowList.clear();
    for (int i = 0; i < _originalTestCase.length; i++) {
      rowList.add(
        TestCaseRow(
          actualPosition: [i],
          parentData: null,
          isGroup: _originalTestCase[i].children != null,
          testCase: _originalTestCase[i],
        ),
      );
    }
  }

  void _forDownloadTableRender() {
    rowList.clear();
    _renderFirstRoot();
    _renderAllDeepChildrenForDownload();
  }

  List<TestCaseRow> _getExpandedChildList({
    required TestCaseRow parentRowData,
    required TestCase parentActualData,
  }) {
    List<TestCaseRow> expandedData = [];
    final children = parentActualData.children ?? [];
    for (int i = 0; i < children.length; i++) {
      ChildType childType =
          _getChildType(i: i, familyMembersLength: children.length);
      expandedData.add(
        TestCaseRow(
          parentData: ParentData(
            childType: childType,
            parents: [
              ...parentRowData.parentData?.parents ?? [],
              parentActualData.testName,
            ],
            actualParent: parentRowData,
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
    _removeAfterParentSiblings(parentUIIndex, grandParentIndexString);
    _removeBeforeParentSiblings(parentUIIndex, grandParentIndexString);
  }

  void _removeAfterParentSiblings(int parentUIIndex, String grandParentIndex) {
    if (parentUIIndex + 1 >= rowList.length) return;
    int? removeStart;
    int? removeEnd;
    for (int i = parentUIIndex + 1; i < rowList.length; i++) {
      if (rowList[i].parentData == null) {
        break;
      }
      if (rowList[i].parentData?.actualParent.actualPosition.toString() ==
          grandParentIndex) {
        removeStart ??= i;
        removeEnd = i;
      } else {
        break;
      }
    }
    if (removeStart != null && removeEnd != null) {
      rowList.removeRange(removeStart, removeEnd + 1);
    }
  }

  void _removeBeforeParentSiblings(int parentUIIndex, String grandParentIndex) {
    if (parentUIIndex - 1 <= 0) return;
    int? removeStart, removeEnd;
    for (int i = parentUIIndex - 1; i >= 0; i--) {
      if (rowList[i].parentData == null) {
        break;
      }
      if (rowList[i].parentData?.actualParent.actualPosition.toString() ==
          grandParentIndex) {
        removeStart = i;
        removeEnd ??= i;
      } else {
        break;
      }
    }
    if (removeStart != null && removeEnd != null) {
      rowList.removeRange(removeStart, removeEnd + 1);
    }
  }

  void _updateUIListWithNewExpandedChildList({
    required TestCaseRow parentTestCase,
    required List<TestCaseRow> expandedData,
    bool preserveSelf = true,
  }) {
    int parentIndex = _getParentIndex(parentTestCase.actualPosition);
    bool isNotFirst = parentIndex != 0;
    bool isNotLast = parentIndex != rowList.length - 1;
    rowList = [
      if (isNotFirst) ...rowList.sublist(0, parentIndex),
      if (preserveSelf) parentTestCase,
      ...expandedData,
      if (isNotLast) ...rowList.sublist(parentIndex + 1, rowList.length),
    ];
  }

  int _getParentIndex(List<int> actualParentLocation) {
    return rowList.indexWhere((element) =>
        element.actualPosition.toString() == actualParentLocation.toString());
  }

  void _renderAllDeepChildrenForDownload() {
    int depth = 0;
    //Can infinitely loop if some logic are changed
    while (true) {
      // ignore: avoid_print
      print("Expanding Deep Children");
      bool foundSomethingToExpand = _findAndExpand(rowList, depth);
      if (!foundSomethingToExpand) {
        break;
      }
      depth++;
    }
  }

  bool _findAndExpand(List<TestCaseRow> parentTestCaseList, int depth) {
    final listToBeCheckedAndExpanded = [...parentTestCaseList];
    bool foundSomethingToExpand = false;
    for (var element in listToBeCheckedAndExpanded) {
      if (element.actualPosition.length <= depth) continue;
      if (element.testCase.children == null) continue;
      if (element.testCase.children!.isEmpty) continue;
      foundSomethingToExpand = true;
      expandChildren(
          parentTestCase: element, removeSiblingsAndRemoveParent: false);
    }
    return foundSomethingToExpand;
  }
}
