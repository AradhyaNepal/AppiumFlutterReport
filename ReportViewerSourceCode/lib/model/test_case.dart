enum Status { success, failed, error, skipped, none }

class TestCase {
  String testName;
  String time;
  Status status;
  String extraLog;
  String duration;
  List<String> steps;
  List<String> screenshots;
  List<TestCase>? children;

  TestCase({
    required this.testName,
    required this.time,
    required this.status,
    required this.extraLog,
    required this.duration,
    required this.steps,
    required this.screenshots,
    required this.children,
  });

  factory TestCase.fromJson(Map<String, dynamic> map) {
    return TestCase(
      testName: map["testName"],
      time: map["time"],
      status: _getStatus(map["status"]),
      extraLog: map["extraLog"],
      duration: map["duration"],
      steps: (map["steps"] as List).map((e) => e.toString()).toList(),
      screenshots:
          (map["screenshots"] as List).map((e) => e.toString()).toList(),
      children: map["children"] == null
          ? null
          : (map["children"] as List).map((e) => TestCase.fromJson(e)).toList(),
    );
  }

  static Status _getStatus(String serverValue) {
    switch (serverValue) {
      case TestCase.success:
        return Status.success;
      case TestCase.failed:
        return Status.failed;
      case TestCase.error:
        return Status.error;
      case TestCase.skipped:
        return Status.skipped;
      default:
        return Status.none;
    }
  }

  static const String success = "Success";
  static const String failed = "Failed";
  static const String error = "Error";
  static const String skipped = "Skipped";
  static const String none = "None";

  static String getStringStatus(Status status) {
    switch (status) {
      case Status.success:
        return TestCase.success;
      case Status.failed:
        return TestCase.failed;
      case Status.error:
      case Status.skipped:
        return TestCase.skipped;
      case Status.none:
        return TestCase.none;
    }
  }
}
