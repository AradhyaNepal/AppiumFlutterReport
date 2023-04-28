import 'package:appium_report/model/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/is_big.dart';
import '../../../model/capabilities.dart';
import '../model/box_widget_data.dart';
import 'box_widget.dart';

class CapabilitiesAndDetailsWidget extends StatelessWidget {
  final Report report;

  const CapabilitiesAndDetailsWidget({
    required this.report,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool screenIsSmall = isSmall(context);
    if (screenIsSmall) {
      return Column(
        children: [
          DetailsWidget(
            report: report,
            forSmallDevice: screenIsSmall,
          ),
          SizedBox(
            height: 20.h,
          ),
          CapabilitiesWidget(
            capabilities: report.capabilities,
            forSmallDevice: screenIsSmall,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: DetailsWidget(
              report: report,
              forSmallDevice: screenIsSmall,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: CapabilitiesWidget(
              capabilities: report.capabilities,
              forSmallDevice: screenIsSmall,
            ),
          ),
        ],
      );
    }
  }
}

class CapabilitiesWidget extends StatelessWidget {
  final bool forSmallDevice;
  final Capabilities capabilities;

  const CapabilitiesWidget({
    required this.capabilities,
    required this.forSmallDevice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxWidget(
      topBoxDataList: [
        TopBoxData(heading: "Automation", value: capabilities.automationName),
        TopBoxData(heading: "Platform", value: capabilities.platformName),
        TopBoxData(heading: "Device", value: capabilities.deviceName),
        TopBoxData(heading: "Package", value: capabilities.appPackage),
        TopBoxData(heading: "Activity", value: capabilities.appActivity),
      ],
      canMinimizeExpand: forSmallDevice,
      heading: 'Capabilities',
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final Report report;
  final bool forSmallDevice;

  const DetailsWidget({
    required this.report,
    required this.forSmallDevice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxWidget(
      topBoxDataList: [
        TopBoxData(heading: "Start Time", value: report.time),
        TopBoxData(heading: "Testing Duration", value: report.duration),
        TopBoxData(
            heading: "Report Generating Duration",
            value: report.generatingReportTime),
        TopBoxData(heading: "Language", value: report.capabilities.language),
        TopBoxData(heading: "", value: "", isPlaceHolder: true),
      ],
      canMinimizeExpand: forSmallDevice,
      heading: 'Basic Details',
    );
  }
}
