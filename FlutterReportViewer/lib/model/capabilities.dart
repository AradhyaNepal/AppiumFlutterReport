class Capabilities {
  String platformName;
  String automationName;
  String deviceName;
  String appPackage;
  String appActivity;
  String language;
  String locale;

  Capabilities({
    required this.platformName,
    required this.automationName,
    required this.deviceName,
    required this.appPackage,
    required this.appActivity,
    required this.language,
    required this.locale,
  });

  factory Capabilities.fromJson(Map<String, dynamic> map) {
    return Capabilities(
      platformName: map["platformName"],
      automationName: map["automationName"],
      deviceName: map["deviceName"],
      appPackage: map["appPackage"],
      appActivity: map["appActivity"],
      language: map["language"] ?? "eng",
      locale: map["locale"] ?? "eng",
    );
  }
}
