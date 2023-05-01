import 'package:appium_report/model/report.dart';
import 'package:appium_report/screens/report_details/model/test_case_row_data.dart';
import 'package:flutter/material.dart';
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
          return TestCaseRowWidget(data: list[index]);
        },
        childCount: list.length,
      ),
    );
  }
}

class TestCaseRowWidget extends StatelessWidget {
  final TestCaseRow data;

  const TestCaseRowWidget({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Builder(
                builder: (context){
                  final parent=data.parentData;
                  if(parent==null)return const SizedBox();
                  return parent.childType==ChildType.first?Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          Provider.of<TestCaseDataController>(context,listen: false).goBack(
                            nearestParentPosition: parent.actualParent.actualPosition,
                            targetedParentDepth: parent.actualParent.actualPosition.length-1,
                          );
                        },
                        icon: const Icon(
                          Icons.backspace,
                        ),
                      ),
                      for (int depth=1;depth<=data.parentData!.actualParent.actualPosition.length;depth++)
                        TextButton(
                            onPressed: (){
                              Provider.of<TestCaseDataController>(context,listen: false).goBack(
                                  nearestParentPosition: parent.actualParent.actualPosition,
                                  targetedParentDepth: depth,
                              );
                            },
                            child: Text(
                              parent.parents[depth-1],
                            ),
                        ),

                    ],
                  ):const SizedBox();


                },
            ),
            Text(data.testCase.testName),
          ],
        ),
        data.isGroup?IconButton(
            onPressed: (){
              if(data.testCase.children==null)return;
              if(data.testCase.children!.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Children Found To Expand")));
              }
              Provider.of<TestCaseDataController>(context,listen: false).expandChildren(parentTestCase: data);
            },
            icon: Icon(
                Icons.expand_more,
            ),
        ):SizedBox(),
      ],
    );
  }
}
