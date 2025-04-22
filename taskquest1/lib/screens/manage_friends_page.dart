import 'package:flutter/material.dart';
import 'components/const/colors.dart';

class ManageFriendsPage extends StatefulWidget {
  @override
  _ManageFriendsPageState createState() => _ManageFriendsPageState();
}

class _ManageFriendsPageState extends State<ManageFriendsPage> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy Data for now (later you can fetch this from Firestore)
  List<String> _friends = ['Ammar', 'Kareema', 'Diana'];
  List<String> _searchResults = ['Camilla', 'John', 'Emily', 'Sam'];

  String _searchQuery = '';

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _addFriend(String username) {
    setState(() {
      _friends.add(username);
      _searchResults.remove(username);
    });

    // Later you'll actually call Firebase here to send a friend request.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request sent to $username!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredResults = _searchResults
        .where((user) => user.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Friends'),
        backgroundColor: primaryGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Friends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _friends.isEmpty
                ? Text('No friends yet. Start adding some!')
                : Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _friends.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text(_friends[index])),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by username',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _performSearch,
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredResults.isEmpty
                  ? Center(child: Text('No users found'))
                  : ListView.builder(
                itemCount: filteredResults.length,
                itemBuilder: (context, index) {
                  final user = filteredResults[index];
                  return ListTile(
                    title: Text(user),
                    trailing: ElevatedButton(
                      onPressed: () => _addFriend(user),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
