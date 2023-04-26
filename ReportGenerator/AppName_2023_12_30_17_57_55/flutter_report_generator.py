class FlutterReportGenerator:
    private reportData=ReportData()

    def generateReport(self):
        print("generate")


class ReportData:
    String time
    Stringn duration
    Capabilities capabilites
    List<TestCaseData> testCaseData


class Capabilities:
    String platformName
    String automationName
    String deviceName
    String appPackage
    String appActivity
    String language
    String locale

class TestCaseData:
    String time
    String duration
    bool status
    String testName
    String extraLog
    List<String> steps
    List<String> screenshots
    List<TestCaseData> children