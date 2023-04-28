import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/model/test_result_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/is_big.dart';
import '../../../model/report.dart';

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
  bool _forGroup = false;
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 750),
      alignment: Alignment.topCenter,
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            TestResultHeadingWidget(
              forGroup: _forGroup,
              toggleGroup: (bool value) {
                setState(() {
                  _forGroup = value;
                  _isExpanded = true;
                });
              },
              toggleExpanded: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              isExpanded: _isExpanded,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
              padding: _isExpanded
                  ? EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 5.w,
                    )
                  : null,
              child: Column(
                children: [
                  if (_isExpanded)
                    for (var item in widget.report.finalCalculatedData)
                      TestResultItemWidget(
                        testResultData: item,
                        isGroup: _forGroup,
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestResultHeadingWidget extends StatefulWidget {
  const TestResultHeadingWidget({
    super.key,
    required bool forGroup,
    required this.toggleGroup,
    required this.toggleExpanded,
    required this.isExpanded,
  }) : _forGroup = forGroup;

  final bool _forGroup;
  final Function(bool value) toggleGroup;
  final Function toggleExpanded;
  final bool isExpanded;

  @override
  State<TestResultHeadingWidget> createState() =>
      _TestResultHeadingWidgetState();
}

class _TestResultHeadingWidgetState extends State<TestResultHeadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
          bottomLeft: widget.isExpanded ? Radius.zero : Radius.circular(10.r),
          bottomRight: widget.isExpanded ? Radius.zero : Radius.circular(10.r),
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                "${widget._forGroup ? "Group" : "Test Case"} Status",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isSmall(context) ? 11.sp : 4.5.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              Switch(
                value: widget._forGroup,
                onChanged: widget.toggleGroup,
              ),
              IconButton(
                onPressed: () {
                  widget.toggleExpanded();
                },
                icon: Icon(
                  widget.isExpanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
                iconSize: isSmall(context) ? 20.sp : 8.sp,
                color: Colors.white,
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TestResultItemWidget extends StatelessWidget {
  final TestResultData testResultData;
  final bool isGroup;

  const TestResultItemWidget({
    required this.testResultData,
    required this.isGroup,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 7.5.h,
      ),
      child: Row(
        children: [
          const Spacer(
            flex: 2,
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                getIcon(context),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "${isGroup ? testResultData.forGroup : testResultData.forTestCase} ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmall(context) ? 12.sp : 5.sp,
                  ),
                ),
                Text(
                  TestCase.getStringStatus(testResultData.status),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isSmall(context) ? 11.5.sp : 4.5.sp,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
