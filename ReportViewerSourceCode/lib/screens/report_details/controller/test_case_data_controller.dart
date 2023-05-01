import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';
import 'package:flutter/material.dart';

class TestCaseDataController with ChangeNotifier {
  List<TestCaseRowData> rowList = [];

  final List<TestCase> _originalTestCase;

  TestCaseDataController(this._originalTestCase) {
    _renderFirstRoot();
  }


  void expandChildren({
    required TestCaseRowData parentTestCase,
    bool removeSiblingsAndRemoveParent = true,
  }) {
    if (parentTestCase.testCase.children == null) return;
    if ((parentTestCase.testCase.children ?? []).isEmpty) return;

    List<TestCaseRowData> expandedData = _getExpandedChildList(
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
  void goBack(List<int> parentLocation, int whichParentLocationIndex) {
    if (whichParentLocationIndex == parentLocation.length - 1) {
      return;
    }
    final newParentLocation =
    parentLocation.sublist(0, whichParentLocationIndex + 1);
    bool weFoundTheStaringOfRemoval = false;
    for (int i = 0; i < rowList.length; i++) {
      if (rowList[i].parentData == null) continue;
      bool elementHaveGeneOfNewParent = rowList[i]
              .parentData!
              .actualParentLocation
              .sublist(0, newParentLocation.length)
              .toString() ==
          newParentLocation.toString();
      if (elementHaveGeneOfNewParent) {
        rowList.removeAt(i);
        weFoundTheStaringOfRemoval = true;
      } else if (weFoundTheStaringOfRemoval) {
        //  The items are stored in a sequence so,
        // Once we had found starting of removal and no more element starts to be found
        // Then there will not be any element next
        break;
      }
    }
    //Expand Children used to restore newParentLocation's Siblings which were deleted previously.
    // expandChildren(
    //     parentTestCase: rowList.firstWhere((element) =>
    //         element.actualPosition.toString() == newParentLocation.toString()));
    notifyListeners();
  }



  void _renderFirstRoot() {
    rowList.clear();
    for (int i = 0; i < _originalTestCase.length; i++) {
      rowList.add(
        TestCaseRowData(
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
    if (parentUIIndex + 1 >= rowList.length) return;
    int? removeStart;
    int? removeEnd;
    for (int i = parentUIIndex + 1; i < rowList.length; i++) {
      if (rowList[i].parentData == null) {
        break;
      }
      if (rowList[i].parentData?.actualParentLocation.toString() ==
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

  void _removeBeforeParentData(int parentUIIndex, String grandParentIndex) {
    if (parentUIIndex - 1 <= 0) return;
    int? removeStart,removeEnd;
    for (int i = parentUIIndex - 1; i >= 0; i--) {
      if (rowList[i].parentData == null) {
        break;
      }
      if (rowList[i].parentData?.actualParentLocation.toString() ==
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
    required TestCaseRowData parentTestCase,
    required List<TestCaseRowData> expandedData,
    bool preserveSelf=true,
  }) {
    int parentIndex = _getParentIndex(parentTestCase.actualPosition);
    bool isNotFirst = parentIndex != 0;
    bool isNotLast = parentIndex != rowList.length - 1;
    rowList = [
      if (isNotFirst) ...rowList.sublist(0, parentIndex),
      if(preserveSelf)parentTestCase,
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

  bool _findAndExpand(List<TestCaseRowData> parentTestCaseList, int depth) {
    final listToBeCheckedAndExpanded = [...parentTestCaseList];
    bool foundSomethingToExpand = false;
    for (var element in listToBeCheckedAndExpanded) {
      if (element.actualPosition.length <= depth) continue;
      if (element.testCase.children == null) continue;
      if (element.testCase.children!.isEmpty) continue;
      foundSomethingToExpand = true;
      expandChildren(parentTestCase: element, removeSiblingsAndRemoveParent: false);
    }
    return foundSomethingToExpand;
  }
}
