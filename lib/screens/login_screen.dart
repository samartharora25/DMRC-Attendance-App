import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: Scan face and check DB
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Face scan coming soon...")));
          },
          child: Text("Scan Face"),
        ),
      ),
    );
  }
}
