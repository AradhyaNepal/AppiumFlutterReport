import 'package:appium_report/model/report.dart';
import 'package:flutter/material.dart';

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
    return const Placeholder();
  }
}
