import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalDividerWidget extends StatelessWidget {
  final bool justPlaceHolder;
  final int subGroupIndex;
  final bool subGroupBorderInLeft;
  final int colorAsSubChild;

  const VerticalDividerWidget({
    this.justPlaceHolder = false,
    this.subGroupIndex = 0,
    this.subGroupBorderInLeft=false,
    this.colorAsSubChild=0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child=subGroupIndex>0?Container(
      width: 1.w,
      height: double.infinity,
      color: Colors.red,
    ):const SizedBox();
    return Row(
      children: [
        if(subGroupBorderInLeft)
          child,
        Container(
          width: 1.w,
          height: justPlaceHolder ? null : double.infinity,
          color: _getColor(context),
        ),
        if(!subGroupBorderInLeft)
          child,
      ],
    );
  }

  Color? _getColor(BuildContext context) {
    if(justPlaceHolder){
      return null;
    }else if(colorAsSubChild==0){
      return Theme.of(context).primaryColor;
    }else{
      return Colors.red;
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
    this.colorAsSubGroup=0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget child=subGroupIndex>0?Container(
      width: double.infinity,
      height: 1.w,
      color: Colors.red,
    ):const SizedBox();

    return Column(
      children: [
        if(subGroupBorderInTop==true)
          ...[
            child,
            SizedBox(height: 2.w,),
          ],
        Container(
          width: double.infinity,
          height: 1.w,
          color: colorAsSubGroup==0?Theme.of(context).primaryColor:Colors.red,
        ),
        if(subGroupBorderInTop==false)
          ...[
            SizedBox(height: 2.w,),
            child,
          ],
      ],
    );
  }
}