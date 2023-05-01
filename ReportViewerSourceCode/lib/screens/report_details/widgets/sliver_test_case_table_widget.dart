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
  final TestCaseRowData data;

  const TestCaseRowWidget({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Builder(
                builder: (context){
                  if(data.parentData==null)return const SizedBox();
                  return Row(
                    children: [
                      for (int position=0;position<data.parentData!.actualParentLocation.length;position++)
                        IconButton(
                          onPressed: (){
                            Provider.of<TestCaseDataController>(context,listen: false).goBack(data.parentData!.actualParentLocation, position);
                          },
                          icon: Icon(
                            Icons.backspace,
                          ),
                        )
                    ],
                  );


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
