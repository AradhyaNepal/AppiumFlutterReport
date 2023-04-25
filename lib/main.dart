import 'package:appium_report/screens/homescreen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Appium Flutter Report',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: HomeScreen.route,
          routes: {
            HomeScreen.route: (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}
