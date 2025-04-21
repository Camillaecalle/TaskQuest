import 'package:flutter/material.dart';
import 'components/const/colors.dart';

class AvatarDesignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Design Avatar'),
        backgroundColor: primaryGreen,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Avatar customization coming soon!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
