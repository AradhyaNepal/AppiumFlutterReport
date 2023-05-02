import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/colors.dart';

class VerticalDividerWidget extends StatelessWidget {
  final bool justPlaceHolder;
  final int subGroupIndex;

  const VerticalDividerWidget({
    this.justPlaceHolder = false,
    this.subGroupIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: justPlaceHolder ? null : double.infinity,
      color: _getColor(context),
    );
  }

  Color? _getColor(BuildContext context) {
    if (justPlaceHolder) {
      return null;
    } else if (subGroupIndex == 0) {
      return Theme.of(context).primaryColor;
    } else {
      return ColorConstant.kSecondaryColor;
    }
  }
}

class HorizontalDividerWidget extends StatelessWidget {
  final int subGroupIndex;
  final bool? subGroupBorderInTop;
  final int colorAsSubGroup;

  const HorizontalDividerWidget({
    this.subGroupIndex = 0,
    this.subGroupBorderInTop,
    this.colorAsSubGroup = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = subGroupIndex > 0
        ? Container(
            width: double.infinity,
            height: 1.w,
            color: ColorConstant.kSecondaryColor,
          )
        : const SizedBox();

    return Column(
      children: [
        if (subGroupBorderInTop == true) ...[
          child,
          SizedBox(
            height: 2.w,
          ),
        ],
        Container(
          width: double.infinity,
          height: 1.w,
          color: colorAsSubGroup == 0
              ? Theme.of(context).primaryColor
              : ColorConstant.kSecondaryColor,
        ),
        if (subGroupBorderInTop == false) ...[
          SizedBox(
            height: 2.w,
          ),
          child,
        ],
      ],
    );
  }
}
