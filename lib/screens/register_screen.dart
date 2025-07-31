import 'package:flutter/material.dart';
import 'package:myapp/screens/camera_capture_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
    RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _empIdController = TextEditingController();

  void _registerFace() async {
  String name = _nameController.text.trim();
  String empId = _empIdController.text.trim();

  if (name.isEmpty || empId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Enter name and employee ID")),
    );
    return;
  }

  // Navigate to camera screen
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CameraCaptureScreen(name: name, empId: empId),
    ),
  );

  if (result != null && result == 'captured') {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Face registered successfully")),
    );
  }
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