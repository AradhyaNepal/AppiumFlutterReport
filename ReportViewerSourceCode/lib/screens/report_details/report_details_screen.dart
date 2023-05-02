import 'dart:convert';
import 'dart:html';
import 'package:appium_report/screens/report_details/widgets/search_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../common/widgets/app_bar_title_widget.dart';
import '../../model/report.dart';
import 'controller/test_case_data_controller.dart';
import 'widgets/capabilities_and_details_widget.dart';
import 'widgets/sliver_test_case_table_widget.dart';
import 'widgets/test_result_widget.dart';
class ReportDetailsScreen extends StatelessWidget {
  final Report report;

  const ReportDetailsScreen({
    required this.report,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TestCaseDataController(report.result),
      child: _ReportDetailsContent(report: report),
    );
  }
}

class _ReportDetailsContent extends StatefulWidget {
  const _ReportDetailsContent({
    super.key,
    required this.report,
  });

  final Report report;

  @override
  State<_ReportDetailsContent> createState() => _ReportDetailsContentState();
}

class _ReportDetailsContentState extends State<_ReportDetailsContent> {
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitleWidget(
          title: "${widget.report.appName} Report",
        ),
        actions: kIsWeb?[
          Tooltip(
            message: "Download File",
            child: IconButton(
                onPressed: ()async{
                  setState(() {
                    forDownload=true;
                  });
                  Provider.of<TestCaseDataController>(context,listen: false).renderForDownloadTable();
                  final image=await screenshotController.capture();
                  if(image==null)return;
                  final content = base64Encode(image);
                  AnchorElement(
                      href: "data:application/octet-stream;charset=utf-16le;base64,$content")
                    ..setAttribute("download", "file.png")
                    ..click();
                  if(!mounted)return;
                  Provider.of<TestCaseDataController>(context,listen: false).renderOptimizedTable();
                  setState(() {
                    forDownload=false;
                  });
                },
                icon: const Icon(
                  Icons.download,
                )
            ),
          ),
          SizedBox(width: 5.w,),
        ]:null,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        child: CustomScrollView(
          shrinkWrap: forDownload,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 20.h,
                    ),
                    CapabilitiesAndDetailsWidget(
                      report: widget.report,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TestResultWidget(
                      report: widget.report,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const SearchWidget(),
                  ],
                )),
            SliverTestCaseTableWidget(
              report: widget.report,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
