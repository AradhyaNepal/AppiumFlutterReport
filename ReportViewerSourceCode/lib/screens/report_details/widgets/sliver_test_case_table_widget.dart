import 'package:appium_report/model/report.dart';
import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';
import 'package:appium_report/screens/report_details/widgets/row_structure_widget.dart';
import 'package:appium_report/screens/report_details/widgets/vertical_horizontal_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/test_case_data_controller.dart';
import 'first_sub_child_navigation_widget.dart';
import 'first_root_child_header_widget.dart';

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
    final subGroupIndex=data.parentData==null?0:data.parentData!.actualParent.actualPosition.length;
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
          stepsWidget: StepsWidget(data: data),
          durationWidget: Text(
            data.testCase.duration,
          ),
          statusWidget: Report.getStatusIcon(
            data.testCase.status,
          ),
          isHeader: false,
          subGroupIndex: subGroupIndex,
        ),
        GroupOrRootTestCaseBottomDividerWidget(
          data: data,
        ),
      ],
    );
  }
}



class StepsWidget extends StatelessWidget {
  const StepsWidget({
    super.key,
    required this.data,
  });

  final TestCaseRow data;

  @override
  Widget build(BuildContext context) {
    if (data.testCase.steps.isEmpty) {
      return const Text("--");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.testCase.steps
          .map(
            (e) => Text(
          e.isEmpty ? "--" : e,
        ),
      )
          .toList(),
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
      return GestureDetector(
        onTap: () {
          if (data.testCase.children == null) return;
          if (data.testCase.children!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No Children Found To Expand")));
          }
          Provider.of<TestCaseDataController>(context, listen: false)
              .expandChildren(parentTestCase: data);
        },
        child: const Icon(
          Icons.arrow_drop_down,
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          //Todo: Open Testcase details screen
        },
        child: const Icon(
          Icons.visibility,
        ),
      );
    }
  }
}

class GroupOrRootTestCaseBottomDividerWidget extends StatelessWidget {
  final TestCaseRow data;
  const GroupOrRootTestCaseBottomDividerWidget({
    required this.data,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentData=data.parentData;
    if(parentData==null){
      return const HorizontalDividerWidget();
    }
    int subGroupIndex=parentData.actualParent.actualPosition.length;
    if(parentData.childType!=ChildType.last){
      return HorizontalDividerWidget(colorAsSubGroup: subGroupIndex,);
    }else{
      return
        HorizontalDividerWidget(
        subGroupIndex: subGroupIndex,
        subGroupBorderInTop: true,
      );
    }
  }
}