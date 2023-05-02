import 'package:appium_report/screens/report_details/widgets/vertical_horizontal_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowStructureWidget extends StatelessWidget {
  final Widget testActionWidget;
  final Widget nameWidget;
  final Widget durationWidget;
  final Widget statusWidget;
  final Widget stepsWidget;
  final bool isHeader;
  final int subGroupIndex;

  const RowStructureWidget({
    required this.testActionWidget,
    required this.nameWidget,
    required this.durationWidget,
    required this.statusWidget,
    required this.stepsWidget,
    required this.isHeader,
    this.subGroupIndex=0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          VerticalDividerWidget(
            justPlaceHolder: isHeader,
            subGroupIndex: subGroupIndex,
          ),
          Expanded(
            flex: 1,
            child: CellWrapperWidget(
              child: testActionWidget,
            ),
          ),
          VerticalDividerWidget(
            subGroupIndex: subGroupIndex,
          ),
          Expanded(
            flex: 2,
            child: CellWrapperWidget(
              child: nameWidget,
            ),
          ),
          VerticalDividerWidget(
            subGroupIndex: subGroupIndex,
          ),
          Expanded(
            flex: 1,
            child: CellWrapperWidget(
              child: durationWidget,
            ),
          ),
          VerticalDividerWidget(
            subGroupIndex: subGroupIndex,
          ),
          Expanded(
            flex: 1,
            child: CellWrapperWidget(
              child: statusWidget,
            ),
          ),
          VerticalDividerWidget(
            subGroupIndex: subGroupIndex,
          ),
          Expanded(
            flex: 2,
            child: CellWrapperWidget(
              child: stepsWidget,
            ),
          ),
          VerticalDividerWidget(
            justPlaceHolder: isHeader,
            subGroupIndex: subGroupIndex,
          ),
        ],
      ),
    );
  }
}

class CellWrapperWidget extends StatelessWidget {
  const CellWrapperWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 7.5.h,
        horizontal: 4.w,
      ),
      child: child,
    );
  }
}


