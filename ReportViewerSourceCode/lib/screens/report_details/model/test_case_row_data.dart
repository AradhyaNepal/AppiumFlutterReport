import 'package:appium_report/model/test_case.dart';

enum ChildType {
  first,
  mid,
  last,
}

class TestCaseRowData {
  final int currentIndex;
  final TestCase testCase;
  final ChildOpenedData? childOpenedData;
  final bool isGroup;

  TestCaseRowData({
    required this.testCase,
    required this.childOpenedData,
    required this.currentIndex,
    required this.isGroup,
  }) : assert(!isGroup && childOpenedData != null,
            "Only Group Can Have Child Data");
}

class ChildOpenedData {
  ///Index from first element as first parent to last element as last parent
  List<int> parentIndexLocation;
  List<String> parents;
  ChildType childType;

  ChildOpenedData({
    required this.childType,
    required this.parents,
    required this.parentIndexLocation,
  });
}
