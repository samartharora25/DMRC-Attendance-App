import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
    RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _empIdController = TextEditingController();

  void _registerFace() {
    String name = _nameController.text.trim();
    String empId = _empIdController.text.trim();

    if (name.isEmpty || empId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter name and employee ID")));
      return;
    }

    // TODO: Launch camera and capture face
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Face capture coming next...")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _empIdController, decoration: InputDecoration(labelText: "Employee ID")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _registerFace, child: Text("Capture Face & Register"))
          ],
        ),
      ),
    );
  }
}
