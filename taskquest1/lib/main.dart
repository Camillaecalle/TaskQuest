import 'package:flutter/material.dart';
import 'screens/authentication_ui.dart';
import 'screens/components/const/colors.dart';
import 'screens/task_manager_page.dart';
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: primaryGreen,  // Set primary color to the defined green
//         colorScheme: ColorScheme.fromSwatch().copyWith(
//           secondary: secondaryGreen,  // Set accent color using secondary
//         ),
//         scaffoldBackgroundColor: backgroundColor,  // Set background color
//         textTheme: TextTheme(
//           bodyLarge: TextStyle(color: textColor),
//           bodyMedium: TextStyle(color: textColor),
//           headlineLarge: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
//           headlineMedium: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
//         ),
//
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: primaryGreen,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             elevation: 0,
//           ),
//         ),
//
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: AuthenticationUI(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'screens/task_manager_page.dart'; // make sure this path is correct
// import 'screens/components/colors.dart'; // to keep the theme consistent

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: lightGreen,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryGreen),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskManagerPage(),
    );
  }
}
