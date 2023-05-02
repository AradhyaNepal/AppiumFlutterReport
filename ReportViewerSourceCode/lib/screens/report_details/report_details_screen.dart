import 'package:appium_report/screens/report_details/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/app_bar_title_widget.dart';
import '../../model/report.dart';
import 'controller/test_case_data_controller.dart';
import 'widgets/capabilities_and_details_widget.dart';
import 'widgets/sliver_test_case_table_widget.dart';
import 'widgets/test_result_widget.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;

  const ReportDetailsScreen({required this.report, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TestCaseDataController(report.result),
      child: _ReportDetailsContent(report: report),
    );
  }
}

class _ReportDetailsContent extends StatelessWidget {
  const _ReportDetailsContent({
    super.key,
    required this.report,
  });

  final Report report;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleWidget(
          title: "${report.appName} Report",
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 20.h,
                ),
                CapabilitiesAndDetailsWidget(
                  report: report,
                ),
                SizedBox(
                  height: 20.h,
                ),
                TestResultWidget(
                  report: report,
                ),
                SizedBox(
                  height: 20.h,
                ),
                const SearchWidget(),
              ],
            )),
            SliverTestCaseTableWidget(
              report: report,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
