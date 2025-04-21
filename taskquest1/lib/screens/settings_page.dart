import 'package:flutter/material.dart';
import 'components/const/colors.dart';
import 'avatar_design_page.dart';

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

      ],
    );
  }
}
