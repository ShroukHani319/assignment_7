import 'package:assignment_7/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controller/theme_controller.dart';

void main() async {
  // Initialize Hive for Flutter

  await Hive.initFlutter();

  // Open a default box to use across the app
  await Hive.openBox('my_task');
  await Hive.openBox('done_task');
  await Hive.openBox('profile');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeController themeController = ThemeController();
    return ListenableBuilder(
      listenable: themeController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          themeMode: themeController.themeMode,
          home: HomeScreen(theme: themeController),
        );
      },
    );
  }
}
