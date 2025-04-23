import 'package:flutter/material.dart';
import 'components/const/colors.dart';
import 'my_friends_page.dart'; // <-- NEW PAGE

class ManageFriendsPage extends StatefulWidget {
  @override
  _ManageFriendsPageState createState() => _ManageFriendsPageState();
}

class _ManageFriendsPageState extends State<ManageFriendsPage> {
  final TextEditingController _searchController = TextEditingController();

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
          children: [
            // Search Bar
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

            // View Friends Button
// View Friends Button
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyFriendsPage(friends: _friends)),
                  );
                },
                icon: Icon(Icons.people, color: Colors.white),
                label: Text('View All Friends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Search Results
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
