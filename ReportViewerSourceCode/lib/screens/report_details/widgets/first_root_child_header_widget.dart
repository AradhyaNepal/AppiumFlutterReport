
import 'package:appium_report/screens/report_details/widgets/row_structure_widget.dart';
import 'package:appium_report/screens/report_details/widgets/sliver_test_case_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/test_case_row_data.dart';

class FirstRootElementHeadingWidget extends StatelessWidget {
  final TestCaseRow data;
  final ChildType rootParentType;

  const FirstRootElementHeadingWidget({
    required this.data,
    required this.rootParentType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (rootParentType != ChildType.first) return const SizedBox();
    const style = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5.r),
            topLeft: Radius.circular(5.r),
          )),
      child: const RowStructureWidget(
        testActionWidget: Text(
          "Action",
          style: style,
        ),
        nameWidget: Text(
          "Test or Group Name",
          style: style,
        ),
        durationWidget: Text(
          "Duration",
          style: style,
        ),
        statusWidget: Text(
          "Status",
          style: style,
        ),
        stepsWidget: Text(
          "Steps",
          style: style,
        ),
        isHeader: true,
      ),
    );
  }
}

