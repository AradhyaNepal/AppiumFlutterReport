import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isHovering = false;
  DropzoneViewController? drapDropController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import Test Report"),
      ),
      body: Center(
        child: Stack(
          children: [
            DropzoneView(
              operation: DragOperation.copy,
              cursor: CursorType.grab,
              onCreated: (DropzoneViewController ctrl) =>
                  drapDropController = ctrl,
              onHover: () {
                _updateHovering(true);
              },
              onDrop: (dynamic ev) {
                _updateHovering(false);
                getDataFromDrag(ev);
              },
              onLeave: () {
                _updateHovering(false);
              },
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 500.h,
                  width: 500.h,
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
                          child: Icon(
                            Icons.image_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();
                          if (result == null) return;
                          final value = result.files.first.bytes;
                          if (value == null) return;
                          String jsonContent = String.fromCharCodes(value);
                          final response = json.decode(jsonContent);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 3),
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
                      Text(
                        "Or\nDrag And Drop",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getDataFromDrag(dynamic htmlData) async {
    if (drapDropController == null) return;
    final value = await drapDropController!.getFileData(htmlData);
    String jsonContent = String.fromCharCodes(value);
    final response = json.decode(jsonContent);
  }

  void _updateHovering(bool value) {
    if (_isHovering == value) return;
    setState(() {
      _isHovering = value;
    });
  }
}
