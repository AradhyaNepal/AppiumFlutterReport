import 'package:appium_report/model/test_case.dart';
import 'package:flutter/material.dart';

class TestResultData {
  Status status;
  int forGroup;
  int forTestCase;
  Widget icon;

  TestResultData({
    required this.status,
    required this.forGroup,
    required this.forTestCase,
    required this.icon,
  });
}
