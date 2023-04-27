import 'package:appium_report/model/capabilities.dart';
import 'package:appium_report/model/test_case.dart';

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
        result:
            (map["result"] as List).map((e) => TestCase.fromJson(e)).toList(),
        duration: map["duration"],
        generatingReportTime: map["generatingReportTime"]);
  }
}
