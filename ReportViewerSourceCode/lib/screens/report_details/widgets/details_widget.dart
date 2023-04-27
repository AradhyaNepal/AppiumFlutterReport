import 'package:flutter/material.dart';

import '../../../model/report.dart';

class DetailsWidget extends StatelessWidget {
  final Report report;
  final bool screenIsBig;

  const DetailsWidget({
    required this.report,
    required this.screenIsBig,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
