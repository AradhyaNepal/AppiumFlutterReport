import 'package:flutter/material.dart';

class TopBoxData {
  String heading;
  String value;
  Widget? icon;
  bool isPlaceHolder;

  TopBoxData({
    required this.heading,
    required this.value,
    this.isPlaceHolder = false,
    this.icon,
  });
}
