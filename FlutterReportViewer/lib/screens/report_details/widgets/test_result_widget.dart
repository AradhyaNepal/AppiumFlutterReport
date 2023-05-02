import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/screens/report_details/widgets/box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/report.dart';
import '../model/box_widget_data.dart';

class TestResultWidget extends StatefulWidget {
  final Report report;

  const TestResultWidget({
    required this.report,
    super.key,
  });

  @override
  State<TestResultWidget> createState() => _TestResultWidgetState();
}

class _TestResultWidgetState extends State<TestResultWidget> {
  bool _isMinimized = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BoxWidget(
            topBoxDataList: widget.report.finalCalculatedData.map((e) {
              return TopBoxData(
                  heading: TestCase.getStringStatus(e.status),
                  value: e.forTestCase.toString(),
                  icon: e.icon);
            }).toList(),
            onChanged: () {
              setState(() {
                _isMinimized = !_isMinimized;
              });
            },
            defaultMinimized: _isMinimized,
            canMinimizeExpand: true,
            heading: 'Test Case Result',
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: BoxWidget(
            topBoxDataList: widget.report.finalCalculatedData.map((e) {
              return TopBoxData(
                  heading: TestCase.getStringStatus(e.status),
                  value: e.forTestCase.toString(),
                  icon: e.icon);
            }).toList(),
            onChanged: () {
              setState(() {
                _isMinimized = !_isMinimized;
              });
            },
            defaultMinimized: _isMinimized,
            canMinimizeExpand: true,
            heading: 'Group Result',
          ),
        ),
      ],
    );
  }
}
