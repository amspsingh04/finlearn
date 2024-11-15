import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Import the login page to navigate after logout

// Import the pages you want to navigate to
import 'learn_page.dart';
import 'chat_page.dart';
import 'resources_page.dart';
import 'profile_page.dart'; // Import the ProfilePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Default to light theme
      home: HomePage(), // No night mode parameters needed
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;  // Keep track of selected tab
  
  // List of pages corresponding to each bottom nav button
  final List<Widget> _pages = [
    LearnPage(),      // The Learn page
    ChatPage(),       // The Chat page
    ResourcesPage(),  // The Resources page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Update selected index when a button is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(FirebaseAuth.instance.currentUser?.displayName ?? 'User Name'),
              accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? 'user@example.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);  // Close the drawer first
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut(); // Log out the user
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(), // Navigate to login page
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],  // Display the page corresponding to the selected tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,  // Highlight the current tab
        onTap: _onItemTapped,  // Callback for when a tab is tapped
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Resources',
          ),
        ],
      ),
    );
  }
}
