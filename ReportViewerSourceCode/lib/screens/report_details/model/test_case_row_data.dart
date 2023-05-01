import '../../../model/test_case.dart';

enum ChildType {
  first,
  mid,
  last,
}

class TestCaseRow {
  final ParentData? parentData;
  final bool isGroup;
  final List<int> actualPosition;
  final TestCase testCase;

  TestCaseRow({
    required this.parentData,
    required this.isGroup,
    required this.testCase,
    required this.actualPosition,
  });

  TestCaseRow copyWith() {
    return TestCaseRow(
        parentData: parentData,
        isGroup: isGroup,
        testCase: testCase,
        actualPosition: actualPosition);
  }
}

class ParentData {
  TestCaseRow actualParent;
  List<String> parents;
  ChildType childType;

  ParentData({
    required this.childType,
    required this.parents,
    required this.actualParent,
  });
}
