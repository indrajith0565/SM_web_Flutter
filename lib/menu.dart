// lib/menu.dart
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  final String username;

  const MenuPage({Key? key, required this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Hello, $username!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Home or perform action
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Settings or perform action
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pop(); // Go back to Login page
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to Menu, $username!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
