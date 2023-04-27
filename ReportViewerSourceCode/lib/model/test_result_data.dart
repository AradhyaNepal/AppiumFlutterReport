import 'package:appium_report/model/test_case.dart';

class TestResultData {
  Status status;
  int forGroup;
  int forTestCase;

  TestResultData({
    required this.status,
    required this.forGroup,
    required this.forTestCase,
  });
}
