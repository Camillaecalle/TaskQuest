// import 'package:flutter/material.dart';
// import 'components/const/colors.dart';
// import 'avatar_design_page.dart';
//
// class SettingsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         ListTile(
//           leading: Icon(Icons.person, color: primaryGreen),
//           title: Text('Customize Avatar'),
//           trailing: Icon(Icons.arrow_forward_ios),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AvatarDesignPage()),
//             );
//           },
//         ),
//         Divider(),
//
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'components/const/colors.dart';
import 'avatar_design_page.dart';
// (Assuming you'll create a notification settings page later)

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: Icon(Icons.person, color: primaryGreen),
          title: Text('Customize Avatar'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvatarDesignPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.notifications, color: primaryGreen),
          title: Text('Notification Permissions'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Later you can navigate to a NotificationSettingsPage()
            // For now, you could just show a placeholder page or dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Notification Permissions'),
                content: Text('Need to implement / configure for permissions I think Ammar is doing this'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK', style: TextStyle(color: primaryGreen)),
                  ),
                ],
              ),
            );
          },
        ),
        Divider(),
      ],
    );
  }
}
