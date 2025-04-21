import 'package:flutter/material.dart';
import 'components/const/colors.dart';

class LeaderboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData = [
    {'name': 'Camilla', 'score': 42},
    {'name': 'Ammar', 'score': 38},
    {'name': 'Kareema', 'score': 36},
    {'name': 'Snigdah', 'score': 30},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
    {'name': 'Leo', 'score': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final user = leaderboardData[index];
          final bool isFirstPlace = index == 0; // Highlight only 1st place

          return Card(
            color: isFirstPlace ? Colors.amber[200] : null, // ⭐ Highlight 1st place card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                radius: isFirstPlace ? 28 : 24, // ⭐ Bigger avatar for 1st place
                backgroundColor: isFirstPlace ? Colors.amber : secondaryGreen,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isFirstPlace ? FontWeight.bold : FontWeight.normal,
                    fontSize: isFirstPlace ? 20 : 16,
                  ),
                ),
              ),
              title: Text(
                user['name'],
                style: TextStyle(
                  fontWeight: isFirstPlace ? FontWeight.bold : FontWeight.normal,
                  fontSize: isFirstPlace ? 20 : 16,
                ),
              ),
              trailing: Text(
                '${user['score']} pts',
                style: TextStyle(
                  fontWeight: isFirstPlace ? FontWeight.bold : FontWeight.normal,
                  fontSize: isFirstPlace ? 18 : 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
