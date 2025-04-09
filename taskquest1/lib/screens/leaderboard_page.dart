import 'package:flutter/material.dart';
import 'components/const/colors.dart';

class LeaderboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData = [
    {'name': 'Camilla', 'score': 42},
    {'name': 'Ammar', 'score': 38},
    {'name': 'Kareema', 'score': 36},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: primaryGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: leaderboardData.length,
          itemBuilder: (context, index) {
            final user = leaderboardData[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: secondaryGreen,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('${user['score']} pts'),
              ),
            );
          },
        ),
      ),
    );
  }
}
