import 'package:appium_report/model/capabilities.dart';
import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/model/test_result_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Report {
  String time;
  String appName;
  Capabilities capabilities;
  List<TestCase> result;
  String duration;
  String generatingReportTime;

  Report({
    required this.time,
    required this.appName,
    required this.capabilities,
    required this.result,
    required this.duration,
    required this.generatingReportTime,
  });

  factory Report.fromJson(Map<String, dynamic> map) {
    return Report(
      time: map["time"],
      appName: map["appName"],
      capabilities: Capabilities.fromJson(map["capabilities"]),
      result: (map["result"] as List).map((e) => TestCase.fromJson(e)).toList(),
      duration: map["duration"],
      generatingReportTime: map["generatingReportTime"],
    );
  }

  bool _finalDataCalculated = false;

  List<TestResultData> get finalCalculatedData {
    if (_finalDataCalculated) return _finalCalculatedData;
    _fetchFinalCalculatedData(result);
    _finalDataCalculated = true;
    return _finalCalculatedData;
  }

  void _fetchFinalCalculatedData(List<TestCase> parentTestCaseList) {
    for (final childTestCase in parentTestCaseList) {
      for (int i = 0; i < _finalCalculatedData.length; i++) {
        if (childTestCase.status == _finalCalculatedData[i].status) {
          if (childTestCase.children == null) {
            _finalCalculatedData[i].forTestCase++;
          } else {
            _finalCalculatedData[i].forGroup++;
            _fetchFinalCalculatedData(childTestCase.children ?? []);
          }
          break;
        }
      }
    }
  }

  final padding = EdgeInsets.only(right: 2.5.w);

  late final List<TestResultData> _finalCalculatedData = [
    TestResultData(
      status: Status.success,
      forGroup: 0,
      forTestCase: 0,
      icon: Padding(
        padding: padding,
        child: Report.getStatusIcon(Status.success),
      ),
    ),
    TestResultData(
      status: Status.failed,
      forGroup: 0,
      forTestCase: 0,
      icon: Padding(
        padding: padding,
        child:Report.getStatusIcon(Status.failed),
      ),
    ),
    TestResultData(
      status: Status.error,
      forGroup: 0,
      forTestCase: 0,
      icon: Padding(
        padding: padding,
        child:Report.getStatusIcon(Status.error),
      ),
    ),
    TestResultData(
      status: Status.skipped,
      forGroup: 0,
      forTestCase: 0,
      icon: Padding(
        padding: padding,
        child: Report.getStatusIcon(Status.skipped),
      ),
    ),
    TestResultData(
      status: Status.none,
      forGroup: 0,
      forTestCase: 0,
      icon: Padding(
        padding: padding,
        child: Report.getStatusIcon(Status.none),
      ),
    ),
  ];

  static Icon getStatusIcon(Status status){
    switch(status){
      case Status.success:
        return const Icon(
          Icons.done,
          color: Colors.green,
        );
      case Status.failed:
        return const Icon(
          Icons.close,
          color: Colors.red,
        );
      case Status.error:
        return const Icon(
          Icons.warning_amber,
          color: Colors.red,
        );
      case Status.skipped:
        return const Icon(
          Icons.arrow_right_alt_sharp,
          color: Colors.green,
        );
      case Status.none:
        return const Icon(
          Icons.question_mark,
          color: Colors.black,
        );
    }
  }
}
