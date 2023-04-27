import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/top_box_widget_data.dart';

class TopBoxWidget extends StatefulWidget {
  final bool forSmallDevice;
  final List<TopBoxData> topBoxDataList;
  final String heading;

  const TopBoxWidget({
    required this.topBoxDataList,
    required this.forSmallDevice,
    required this.heading,
    Key? key,
  }) : super(key: key);

  @override
  State<TopBoxWidget> createState() => _TopBoxWidgetState();
}

class _TopBoxWidgetState extends State<TopBoxWidget> {
  bool isExpanded = false;

  @override
  void initState() {
    isExpanded = !widget.forSmallDevice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 500),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: TopBoxHeadingWidget(
                heading: widget.heading,
                isExpanded: isExpanded,
                isSmallScreen: widget.forSmallDevice,
                extraWidget: null,
              ),
            ),
            if (isExpanded || !widget.forSmallDevice)
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 5.h,
                  horizontal: 5.w,
                ),
                child: Column(
                  children: [
                    for (TopBoxData value in widget.topBoxDataList)
                      SingleTopBoxItem(
                        data: value,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SingleTopBoxItem extends StatelessWidget {
  final TopBoxData data;

  const SingleTopBoxItem({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 7.5.h,
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: data.placeHolder
                ? Colors.transparent
                : Theme.of(context).primaryColor,
          ),
          Flexible(
            flex: 2,
            child: Text(
              "${data.heading} ",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Text(
              data.value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopBoxHeadingWidget extends StatelessWidget {
  final String heading;
  final bool isExpanded;
  final bool isSmallScreen;
  final Widget? extraWidget;

  const TopBoxHeadingWidget({
    required this.heading,
    required this.isExpanded,
    required this.isSmallScreen,
    required this.extraWidget,
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
          bottomLeft: isExpanded ? Radius.zero : Radius.circular(10.r),
          bottomRight: isExpanded ? Radius.zero : Radius.circular(10.r),
        ),
        color: Theme.of(context).primaryColor.withOpacity(0.8),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          if (extraWidget != null) ...[
            extraWidget ?? const SizedBox(),
            SizedBox(
              width: 5.w,
            ),
          ],
          Text(
            heading,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (isSmallScreen) ...[
            const Spacer(),
            Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.white,
            ),
            SizedBox(
              width: 5.w,
            ),
          ]
        ],
      ),
    );
  }
}
