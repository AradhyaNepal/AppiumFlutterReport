import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/widgets/app_bar_title_widget.dart';
import '../../model/report.dart';
import '../report_details/report_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isHovering = false;
  DropzoneViewController? drapDropController;

  void _oldFileOpen() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: size.width,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: AppBarTitleWidget(
                    title: "Test Report",
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Tooltip(
                        message: "Mini History",
                        child: IconButton(
                          onPressed: _oldFileOpen,
                          icon: const Icon(Icons.history),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Tooltip(
                        message: "Locally Saved",
                        child: IconButton(
                          onPressed: _oldFileOpen,
                          icon: const Icon(Icons.folder_copy_rounded),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: 600.h,
          width: 300.w,
          child: Stack(
            children: [
              if (kIsWeb)
                Positioned.fill(
                  child: DropzoneView(
                    operation: DragOperation.copy,
                    cursor: CursorType.grab,
                    onCreated: (DropzoneViewController ctrl) =>
                        drapDropController = ctrl,
                    onHover: () {
                      _updateHovering(true);
                    },
                    onDrop: (dynamic ev) {
                      _updateHovering(false);
                      _getDataFromDragAndDrop(ev);
                    },
                    onLeave: () {
                      _updateHovering(false);
                    },
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: _isHovering
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : null,
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 10),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 20.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.h,
                          ),
                          child: Icon(
                            Icons.file_present_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InkWell(
                      onTap: _getDataFromImport,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 3),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Import",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.upload,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (kIsWeb) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 2.5.w,
                          ),
                          Text(
                            "Or",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 2.5.w,
                          ),
                          Expanded(
                            child: Divider(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Drag And Drop",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getDataFromDragAndDrop(dynamic htmlData) async {
    _errorSafeImport(() async {
      if (drapDropController == null) return;
      final value = await drapDropController!.getFileData(htmlData);
      _openReportScreen(value);
    });
  }

  void _getDataFromImport() async {
    _errorSafeImport(() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      final value = result.files.first.bytes;
      _openReportScreen(value);
    });
  }

  void _errorSafeImport(Function function) {
    try {
      function();
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Cannot load. May be file is wrong formatted"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Okay"))
            ],
          );
        },
      );
    }
  }

  void _openReportScreen(Uint8List? value) {
    _errorSafeImport(() {
      if (value == null) return;
      String jsonContent = String.fromCharCodes(value);
      final response = json.decode(jsonContent);
      final report = Report.fromJson(response);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReportDetailsScreen(
          report: report,
        ),
      ));
    });
  }

  void _updateHovering(bool value) {
    if (_isHovering == value) return;
    setState(() {
      _isHovering = value;
    });
  }
}
