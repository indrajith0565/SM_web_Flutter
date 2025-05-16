import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart'; // Make sure this file exists with HomePage

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Map<String, String>> databases = [];
  String? selectedDatabase;

  bool _isLoading = false;
  bool _isFetchingDatabases = true;

  @override
  void initState() {
    super.initState();
    fetchDatabases();
  }

  Future<void> fetchDatabases() async {
    setState(() => _isFetchingDatabases = true);

    final databaseUrl = Uri.parse("https://mysmit.com:8987/WebOrderPortal_TEST_API/api/WebPortalDBList");

    try {
      final response = await http.post(databaseUrl);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        //print("DB List Response: $jsonData");

        if (jsonData["statusCode"] == 1 && jsonData["responseData"] is List) {
          setState(() {
            databases = (jsonData["responseData"] as List)
                .map((db) => {
                      "code": db["code"]?.toString() ?? "",
                      "name": db["name"]?.toString() ?? "",
                    })
                .toList();
          });
        } else {
          print("Unexpected format in responseData.");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching databases: $e");
    } finally {
      setState(() => _isFetchingDatabases = false);
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final loginUrl = Uri.parse("https://mysmit.com:8987/WebOrderPortal_TEST_API/api/WebPortalLogin");
      final body = json.encode({
        "UserName": _usernameController.text.trim(),
        "Password": _passwordController.text.trim(),
        "Database": selectedDatabase
      });

      try {
        final response = await http.post(
          loginUrl,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        final data = json.decode(response.body);
        //print("Login Response: $data");

        if (data["statusCode"] == 1) {
          final userData = data["responseData"];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(userData: userData),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data["responseData"] ?? "Login failed")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login error: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF2F5),
      body: Center(
        child: Container(
          width: 570,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Banner
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/bg-01.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 220, top: 15),
                  child: Row(
                    children: [
                      Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInputField("Username", _usernameController),
                      SizedBox(height: 16),
                      _buildInputField("Password", _passwordController, isPassword: true),
                      SizedBox(height: 16),
                      _isFetchingDatabases
                          ? Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Database",
                                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              ),
                              value: selectedDatabase,
                              items: databases.map((db) {
                                return DropdownMenuItem<String>(
                                  value: db["code"],
                                  child: Text(db["code"] ?? db["name"]!),
                                );
                              }).toList(),
                              onChanged: (value) {  
                                setState(() {
                                  selectedDatabase = value;
                                });
                              },
                              validator: (value) =>
                                  value == null ? "Please select a database" : null,
                            ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: 180,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF40C4A8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (value) =>
          value == null || value.isEmpty ? "Please enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
