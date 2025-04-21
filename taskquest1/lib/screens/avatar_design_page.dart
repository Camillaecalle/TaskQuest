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
          'Users will be able to design avatar here',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
