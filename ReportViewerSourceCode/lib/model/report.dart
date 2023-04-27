import 'package:appium_report/model/capabilities.dart';
import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/model/test_result_data.dart';

class Report {
  String time;
  String appName;
  Capabilities capabilities;
  List<TestCase> result;
  String duration;
  String generatingReportTime;

  List<TestResultData> finalCalculatedData = [
    TestResultData(status: Status.success, forGroup: 10, forTestCase: 1),
    TestResultData(status: Status.failed, forGroup: 9, forTestCase: 2),
    TestResultData(status: Status.error, forGroup: 8, forTestCase: 3),
    TestResultData(status: Status.skipped, forGroup: 7, forTestCase: 4),
    TestResultData(status: Status.none, forGroup: 6, forTestCase: 5),
  ];

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
        result:
            (map["result"] as List).map((e) => TestCase.fromJson(e)).toList(),
        duration: map["duration"],
        generatingReportTime: map["generatingReportTime"]);
  }
}
