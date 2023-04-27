import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/capabilities.dart';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          const HeadingWidget(
            heading: "Capabilities",
          ),
          SingleDetailItem(
            heading: "Automation",
            value: capabilities.automationName,
          ),
          SingleDetailItem(
            heading: 'Platform',
            value: capabilities.platformName,
          ),
          SingleDetailItem(
            heading: 'Device',
            value: capabilities.deviceName,
          ),
          SingleDetailItem(
            heading: 'Package',
            value: capabilities.appPackage,
          ),
          SingleDetailItem(
            heading: 'Activity',
            value: capabilities.appActivity,
          ),
        ],
      ),
    );
  }
}

class SingleDetailItem extends StatelessWidget {
  final String heading;
  final String value;
  const SingleDetailItem({
    required this.heading,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

class HeadingWidget extends StatelessWidget {
  final String heading;
  const HeadingWidget({
    required this.heading,
    super.key,
  });

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
      child: Text(
        heading,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
