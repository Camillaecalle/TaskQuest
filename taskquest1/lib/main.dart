import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/authentication_ui.dart';
import 'screens/components/const/colors.dart';
import 'screens/task_manager_page.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTheme _currentTheme = AppTheme.Default;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appThemeData[_currentTheme],
      home: TaskManagerPage(
        currentTheme: _currentTheme,
        onThemeChanged: (newTheme) {
          setState(() => _currentTheme = newTheme);
        },
      ),
    );
  }
}
