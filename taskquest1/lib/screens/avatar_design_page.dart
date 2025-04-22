import 'package:flutter/material.dart';
import 'components/const/colors.dart';

class AvatarDesignPage extends StatelessWidget {
  // List of avatar image paths
  final List<String> avatarImages = [
    'assets/avatars/turtle.png',
    'assets/avatars/giraffe.png',
    'assets/avatars/Cat.png',
    'assets/avatars/dolphin.png',
    'assets/avatars/cow.png',
    'assets/avatars/panda.png',
    'assets/avatars/zebra.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Avatar'),
        backgroundColor: primaryGreen,
        centerTitle: true,
      ),
      body: PageView.builder(
        itemCount: avatarImages.length,
        itemBuilder: (context, index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(avatarImages[index]),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Unlock with X points!', // You can replace X dynamically later
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
