import '../../../model/test_case.dart';

enum ChildType {
  first,
  mid,
  last,
}

class TestCaseRowData {
  final ParentData? parentData;
  final bool isGroup;
  final List<int> actualPosition;
  final TestCase testCase;

  TestCaseRowData({
    required this.parentData,
    required this.isGroup,
    required this.testCase,
    required this.actualPosition,
  });

  TestCaseRowData copyWith() {
    return TestCaseRowData(
        parentData: parentData,
        isGroup: isGroup,
        testCase: testCase,
        actualPosition: actualPosition);
  }
}

class ParentData {
  ///Index from first element as first parent to last element as last parent
  List<int> actualParentLocation;
  List<String> parents;
  ChildType childType;

  ParentData({
    required this.childType,
    required this.parents,
    required this.actualParentLocation,
  });
}
