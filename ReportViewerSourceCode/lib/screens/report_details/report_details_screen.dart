import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets/app_bar_title_widget.dart';
import '../../model/report.dart';
import 'widgets/capabilities_and_details_widget.dart';
import 'widgets/test_case_result_widget.dart';
import 'widgets/test_case_table_widget.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;

  const ReportDetailsScreen({required this.report, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleWidget(
          title: "${report.appName} Report",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              CapabilitiesAndDetailsWidget(
                report: report,
              ),
              const TestResultWidget(),
              const TestCaseTableWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
