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

  bool _finalDataCalculated = false;

  List<TestResultData> get finalCalculatedData {
    if (_finalDataCalculated) return _finalCalculatedData;
    _fetchFinalCalculatedData(result);
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

  final List<TestResultData> _finalCalculatedData = [
    TestResultData(status: Status.success, forGroup: 0, forTestCase: 0),
    TestResultData(status: Status.failed, forGroup: 0, forTestCase: 0),
    TestResultData(status: Status.error, forGroup: 0, forTestCase: 0),
    TestResultData(status: Status.skipped, forGroup: 0, forTestCase: 0),
    TestResultData(status: Status.none, forGroup: 0, forTestCase: 0),
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
      result: (map["result"] as List).map((e) => TestCase.fromJson(e)).toList(),
      duration: map["duration"],
      generatingReportTime: map["generatingReportTime"],
    );
  }
}
