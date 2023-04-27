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
      status: map["status"],
      extraLog: map["extraLog"],
      duration: map["duration"],
      steps: map["steps"],
      screenshots: map["screenshots"],
      children: map["children"] == null
          ? null
          : (map["children"] as List).map((e) => TestCase.fromJson(e)).toList(),
    );
  }
}
