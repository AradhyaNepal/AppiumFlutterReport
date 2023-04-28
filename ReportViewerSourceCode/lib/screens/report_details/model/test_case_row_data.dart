import 'package:appium_report/model/test_case.dart';

enum ChildType {
  first,
  mid,
  last,
}

class TestCaseRowData {
  final TestCase testCase;
  final ParentData? parentData;
  final bool isGroup;
  final List<int> actualPosition;

  TestCaseRowData({
    required this.testCase,
    required this.parentData,
    required this.isGroup,
    required this.actualPosition,
  }) : assert(!isGroup && parentData != null, "Only Group Can Have Child Data");
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
