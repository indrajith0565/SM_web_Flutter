import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  HomePage({required this.userData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _logoutTimer;

  @override
  void initState() {
    super.initState();
    _startAutoLogoutTimer();
  }

  void _startAutoLogoutTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimeStr = prefs.getString("loginTime");

    if (loginTimeStr != null) {
      final loginTime = DateTime.parse(loginTimeStr);
      final now = DateTime.now();
      final elapsed = now.difference(loginTime);
      final remaining = Duration(minutes: 30) - elapsed;

      if (remaining.isNegative) {
        _logout();
      } else {
        _logoutTimer = Timer(remaining, _logout);
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _logoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: Center(
        child: Text("Welcome, ${widget.userData['userName'] ?? ''}!"),
      ),
    );
  }
}
