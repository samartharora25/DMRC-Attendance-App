import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'image_gallery_screen.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DMRC Facial App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Register'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('View Registered Faces'), // 🔹 New button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ImageGalleryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
