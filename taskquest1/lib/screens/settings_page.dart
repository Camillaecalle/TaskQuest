import 'package:flutter/material.dart';
import 'components/const/colors.dart';
import 'avatar_design_page.dart';
import 'manage_friends_page.dart';
import '../theme.dart';  // for AppTheme enum

class SettingsPage extends StatelessWidget {
  final AppTheme currentTheme;
  final ValueChanged<AppTheme> onThemeChanged;

  const SettingsPage({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Theme selector
        ListTile(
          title: Text(
            'Select App Theme',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          subtitle: DropdownButton<AppTheme>(
            value: currentTheme,
            isExpanded: true,
            items: AppTheme.values.map((mode) {
              final name = mode.toString().split('.').last;
              return DropdownMenuItem(
                value: mode,
                child: Text(name),
              );
            }).toList(),
            onChanged: (mode) {
              if (mode != null) onThemeChanged(mode);
            },
          ),
        ),
        Divider(),

        // Avatar selection
        ListTile(
          leading: Icon(Icons.person, color: primaryGreen),
          title: Text('Select Avatar'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AvatarDesignPage()),
            );
          },
        ),
        Divider(),

        // Notification settings
        ListTile(
          leading: Icon(Icons.notifications, color: primaryGreen),
          title: Text('Notification Permissions'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Notification Permissions'),
                content: Text('Need to implement / configure for permissions.'),
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
