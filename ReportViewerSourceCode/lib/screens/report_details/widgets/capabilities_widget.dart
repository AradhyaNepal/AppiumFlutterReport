import 'package:appium_report/model/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CapabilitiesWidget extends StatelessWidget {
  final bool forSmallDevice;
  final Report report;

  const CapabilitiesWidget({
    required this.report,
    required this.forSmallDevice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Container(
            height: 10.h,
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            child: const Text(
              "Capabilities",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
