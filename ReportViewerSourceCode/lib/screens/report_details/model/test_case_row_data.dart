import 'package:appium_report/model/test_case.dart';

enum ChildType {
  first,
  mid,
  last,
}

class TestCaseRowData {
  int currentIndex;
  final TestCase testCase;
  final ParentData? parentData;
  final bool isGroup;

  TestCaseRowData({
    required this.testCase,
    required this.parentData,
    required this.currentIndex,
    required this.isGroup,
  }) : assert(!isGroup && parentData != null, "Only Group Can Have Child Data");
}

class ParentData {
  ///Index from first element as first parent to last element as last parent
  List<int> parentIndexLocation;
  List<String> parents;
  ChildType childType;

  ParentData({
    required this.childType,
    required this.parents,
    required this.parentIndexLocation,
  });
}
