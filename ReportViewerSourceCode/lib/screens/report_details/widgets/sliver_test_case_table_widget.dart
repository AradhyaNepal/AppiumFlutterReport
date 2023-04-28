import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';
import 'package:flutter/material.dart';

import '../controller/test_case_data_controller.dart';

class SliverTestCaseTableWidget extends StatelessWidget {
  const SliverTestCaseTableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = TestCaseDataController().testCaseWidgetList;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return list[index];
        },
        childCount: list.length,
      ),
    );
  }
}

class TestCaseRowWidget extends StatelessWidget {
  final TestCaseRowData data;

  const TestCaseRowWidget({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
