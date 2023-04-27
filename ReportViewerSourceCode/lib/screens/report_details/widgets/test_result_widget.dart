import 'package:appium_report/model/test_case.dart';
import 'package:appium_report/model/test_result_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          HeadingWidget(
            forGroup: _forGroup,
            toggle: (bool value) {
              setState(() {
                _forGroup = value;
              });
            },
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 5.h,
              horizontal: 5.w,
            ),
            child: Column(
              children: [
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
    );
  }
}

class HeadingWidget extends StatefulWidget {
  const HeadingWidget({
    super.key,
    required bool forGroup,
    required this.toggle,
  }) : _forGroup = forGroup;

  final bool _forGroup;
  final Function(bool value) toggle;

  @override
  State<HeadingWidget> createState() => _HeadingWidgetState();
}

class _HeadingWidgetState extends State<HeadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          Text(
            "${widget._forGroup ? "Group" : "TestCase"} Details",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Switch(
            value: widget._forGroup,
            onChanged: widget.toggle,
          ),
          SizedBox(
            width: 5.w,
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
          getIcon(),
          SizedBox(
            width: 5.w,
          ),
          Text(
            "${isGroup ? testResultData.forGroup : testResultData.forTestCase} ",
          ),
          Text(
            TestCase.getStringStatus(testResultData.status),
          ),
        ],
      ),
    );
  }

  Widget getIcon() {
    switch (testResultData.status) {
      case Status.success:
        return const Icon(
          Icons.done,
          color: Colors.green,
        );
      case Status.failed:
        return const Icon(
          Icons.close,
          color: Colors.red,
        );
      case Status.error:
        return const Icon(
          Icons.warning_amber,
          color: Colors.red,
        );
      case Status.skipped:
        return const Icon(
          Icons.arrow_right_alt_sharp,
          color: Colors.green,
        );
      case Status.none:
        return const Icon(
          Icons.question_mark,
          color: Colors.green,
        );
    }
  }
}
