import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/authentication_ui.dart';
import 'screens/components/const/colors.dart';
import 'screens/task_manager_page.dart';
import 'theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Safely load .env file
  try {
    await dotenv.load();
  } catch (e) {
    print('⚠️ .env file not found or failed to load: $e');
  }

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
