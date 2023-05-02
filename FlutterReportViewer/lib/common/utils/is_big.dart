import 'package:flutter/cupertino.dart';

import '../constants.dart';

bool isSmall(BuildContext context) {
  return MediaQuery.of(context).size.shortestSide < Constant.kBigSmallLimit;
}
