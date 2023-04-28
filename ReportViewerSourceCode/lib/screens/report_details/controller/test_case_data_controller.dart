import 'package:appium_report/model/report.dart';
import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';

class TestCaseDataController {
  List<TestCaseRowData> testCaseWidgetList = [];

  void renderTableData(Report report) {
    for (int i = 0; i < report.result.length; i++) {
      testCaseWidgetList.add(
        TestCaseRowData(
          testCase: report.result[i],
          childOpenedData: null,
          currentIndex: i,
          isGroup: report.result[i].children != null,
        ),
      );
    }
  }
}
