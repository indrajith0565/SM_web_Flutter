// lib/home.dart

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${userData['username']}"),
      ),
      body: Center(
        child: Text("Hello, ${userData['username']}!"),
      ),
    );
  }
}
