import 'package:flutter/material.dart';
import 'components/const/colors.dart';

class MyFriendsPage extends StatelessWidget {
  final List<String> friends;

  MyFriendsPage({required this.friends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Friends'),
        backgroundColor: primaryGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: friends.isEmpty
            ? Center(child: Text('You have no friends yet.'))
            : ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(friends[index]),
                leading: Icon(Icons.person, color: primaryGreen),
              ),
            );
          },
        ),
      ),
    );
  }
}
