import 'package:appium_report/model/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/utils/is_big.dart';
import 'capabilities_widget.dart';
import 'details_widget.dart';

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
            height: 10.h,
          ),
          CapabilitiesWidget(
            capabilities: report.capabilities,
            forSmallDevice: screenIsSmall,
          ),
        ],
      );
    } else {
      return IntrinsicHeight(
        child: Row(
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
        ),
      );
    }
  }
}
