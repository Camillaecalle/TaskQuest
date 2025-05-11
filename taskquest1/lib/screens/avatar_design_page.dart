
import 'package:flutter/material.dart';
import 'components/const/colors.dart';

class AvatarDesignPage extends StatelessWidget {
  final List<String> avatarImages;
  final List<bool> unlockedAvatars;
  final List<int> unlockCosts;
  final int userPoints;

  const AvatarDesignPage({
    Key? key,
    this.avatarImages = const [
      'assets/avatars/turtle.png',
      'assets/avatars/giraffe.png',
      'assets/avatars/Cat.png',
      'assets/avatars/dolphin.png',
      'assets/avatars/cow.png',
      'assets/avatars/panda.png',
      'assets/avatars/zebra.png',
    ],
    this.unlockedAvatars = const [true, true, true, false, false, false, false],
    this.unlockCosts    = const [0,    0,    0,    20,   50,   70,    100],
    this.userPoints     = 0,
  }) : super(key: key);

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
          final isUnlocked = unlockedAvatars[index];
          final cost       = unlockCosts[index];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // White‐background circular avatar
                CircleAvatar(
                  radius: 125,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(avatarImages[index]),
                ),
                SizedBox(height: 20),

                if (isUnlocked) ...[
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, index),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                    child: Text('Select Avatar'),
                  ),
                ] else ...[
                  Text(
                    'Unlock for $cost points',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: userPoints >= cost
                        ? () => Navigator.pop(context, index)
                        : null,
                    style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                    child: Text(
                      userPoints >= cost ? 'Unlock' : 'Insufficient points',
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
