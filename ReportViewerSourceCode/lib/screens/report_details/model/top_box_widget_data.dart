import 'package:flutter/material.dart';

class TopBoxData {
  String heading;
  String value;
  Widget? icon;
  bool placeHolder;

  TopBoxData({
    required this.heading,
    required this.value,
    this.placeHolder = false,
    this.icon,
  });
}
