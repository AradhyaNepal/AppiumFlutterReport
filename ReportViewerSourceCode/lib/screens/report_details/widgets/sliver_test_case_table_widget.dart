import 'package:appium_report/model/report.dart';
import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controller/test_case_data_controller.dart';

class SliverTestCaseTableWidget extends StatelessWidget {
  final Report report;

  const SliverTestCaseTableWidget({
    required this.report,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TestCaseDataController>(context).rowList;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return TestCaseRowWidget(
            data: list[index],
            rootChildType: TestCaseDataController.getChildType(
                i: index, familyMembersLength: list.length),
          );
        },
        childCount: list.length,
      ),
    );
  }
}

class TestCaseRowWidget extends StatelessWidget {
  final TestCaseRow data;
  final ChildType rootChildType;

  const TestCaseRowWidget({
    required this.data,
    required this.rootChildType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FirstRootElementHeadingWidget(
          data: data,
          rootParentType: rootChildType,
        ),
        FirstChildrenNavigatingBackToParentWidget(
          data: data,
        ),
        RowStructureWidget(
          testActionWidget: TestCaseActionWidget(
            data: data,
          ),
          nameWidget: Text(
            data.testCase.testName,
          ),
          stepsWidget: Builder(builder: (context) {
            if (data.testCase.steps.isEmpty) {
              return const Text("--");
            }
            return Column(
              children: data.testCase.steps
                  .map(
                    (e) => Text(
                      e.isEmpty ? "--" : e,
                    ),
                  )
                  .toList(),
            );
          }),
          durationWidget: Text(
            data.testCase.duration,
          ),
          statusWidget: Report.getStatusIcon(
            data.testCase.status,
          ),
        ),
      ],
    );
  }
}

class RowStructureWidget extends StatelessWidget {
  final Widget testActionWidget;
  final Widget nameWidget;
  final Widget durationWidget;
  final Widget statusWidget;
  final Widget stepsWidget;

  const RowStructureWidget({
    required this.testActionWidget,
    required this.nameWidget,
    required this.durationWidget,
    required this.statusWidget,
    required this.stepsWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: testActionWidget,
          ),
          const VerticalDividerWidget(),
          Expanded(
            flex: 2,
            child: nameWidget,
          ),
          const VerticalDividerWidget(),
          Expanded(
            flex: 1,
            child: durationWidget,
          ),
          const VerticalDividerWidget(),
          Expanded(
            flex: 1,
            child: statusWidget,
          ),
          const VerticalDividerWidget(),
          Expanded(
            flex: 2,
            child: stepsWidget,
          ),
        ],
      ),
    );
  }
}

class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: double.infinity,
      color: Theme.of(context).primaryColor,
    );
  }
}


class FirstRootElementHeadingWidget extends StatelessWidget {
  final TestCaseRow data;
  final ChildType rootParentType;
  const FirstRootElementHeadingWidget({
    required this.data,
    required this.rootParentType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if(rootParentType!=ChildType.first)return const SizedBox();
    return const RowStructureWidget(
      testActionWidget: Text(
        "Action"
      ),
      nameWidget: Text(
          "Test or Group Name"
      ),
      durationWidget: Text(
        "Duration",
      ),
      statusWidget: Text(
        "Status"
      ),
      stepsWidget: Text(
        "Steps"
      ),
    );
  }
}

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
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Provider.of<TestCaseDataController>(context, listen: false).goBack(
              nearestParentPosition: parent.actualParent.actualPosition,
              targetedParentDepth:
                  parent.actualParent.actualPosition.length - 1,
            );
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        for (int depth = 1;
            depth <= data.parentData!.actualParent.actualPosition.length;
            depth++) ...[
          TextButton(
            onPressed: () {
              Provider.of<TestCaseDataController>(context, listen: false)
                  .goBack(
                nearestParentPosition: parent.actualParent.actualPosition,
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
    );
  }
}

class TestCaseActionWidget extends StatelessWidget {
  const TestCaseActionWidget({
    super.key,
    required this.data,
  });

  final TestCaseRow data;

  @override
  Widget build(BuildContext context) {
    if (data.isGroup) {
      return IconButton(
        onPressed: () {
          if (data.testCase.children == null) return;
          if (data.testCase.children!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No Children Found To Expand")));
          }
          Provider.of<TestCaseDataController>(context, listen: false)
              .expandChildren(parentTestCase: data);
        },
        icon: const Icon(
          Icons.arrow_drop_down,
        ),
      );
    } else {
      return IconButton(
        onPressed: () {
          //Todo: Open Testcase details screen
        },
        icon: const Icon(
          Icons.visibility,
        ),
      );
    }
  }
}
