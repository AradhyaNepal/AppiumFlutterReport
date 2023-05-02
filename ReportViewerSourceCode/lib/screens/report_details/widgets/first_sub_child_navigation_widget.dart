import 'package:appium_report/screens/report_details/widgets/vertical_horizontal_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controller/test_case_data_controller.dart';
import '../model/test_case_row_data.dart';

class FirstChildrenNavigatingBackToParentWidget extends StatelessWidget {
  final TestCaseRow data;

  const FirstChildrenNavigatingBackToParentWidget({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final parent = data.parentData;
    if (parent == null) return const SizedBox();
    if (parent.childType != ChildType.first) return const SizedBox();
    int subGroupIndex = parent.actualParent.actualPosition.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HorizontalDividerWidget(
          subGroupBorderInTop: false,
          subGroupIndex: subGroupIndex,
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              VerticalDividerWidget(
                subGroupIndex: subGroupIndex,
                subGroupBorderInLeft: false,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 2.w,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<TestCaseDataController>(context,
                              listen: false)
                              .goBack(
                            nearestParentPosition:
                            parent.actualParent.actualPosition,
                            targetedParentDepth:
                            parent.actualParent.actualPosition.length - 1,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_outlined,
                        ),
                      ),
                      for (int depth = 1;
                      depth <=
                          data.parentData!.actualParent.actualPosition
                              .length;
                      depth++) ...[
                        TextButton(
                          onPressed: () {
                            Provider.of<TestCaseDataController>(context,
                                listen: false)
                                .goBack(
                              nearestParentPosition:
                              parent.actualParent.actualPosition,
                              targetedParentDepth: depth,
                            );
                          },
                          child: Text(
                            parent.parents[depth - 1],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                        )
                      ],
                    ],
                  ),
                ),
              ),
              VerticalDividerWidget(
                subGroupIndex: subGroupIndex,
                subGroupBorderInLeft: true,
              ),
            ],
          ),
        ),
        HorizontalDividerWidget(
          colorAsSubGroup: subGroupIndex,
        ),
      ],
    );
  }
}