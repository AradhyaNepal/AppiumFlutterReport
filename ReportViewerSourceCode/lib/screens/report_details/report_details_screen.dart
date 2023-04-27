import 'package:flutter/material.dart';

import '../../common/widgets/app_bar_title_widget.dart';
import '../../model/report.dart';
import 'widgets/capabilities_and_details_widget.dart';
import 'widgets/test_case_result_widget.dart';
import 'widgets/test_case_table_widget.dart';

class ReportDetailsScreen extends StatelessWidget {
  static const String route = "/ReportDetailsScreen";
  final Report report;

  const ReportDetailsScreen({required this.report, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleWidget(
          title: "Report of: ${report.appName}",
        ),
      ),
      body: Column(
        children: [
          CapabilitiesAndDetailsWidget(
            report: report,
          ),
          TestResultWidget(),
          TestCaseTableWidget(),
        ],
      ),
    );
  }
}
