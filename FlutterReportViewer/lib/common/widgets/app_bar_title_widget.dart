import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/is_big.dart';

class AppBarTitleWidget extends StatelessWidget {
  final String title;
  const AppBarTitleWidget({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5.h,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isSmall(context) ? 18.sp : 7.sp,
          ),
        ),
      ),
    );
  }
}
