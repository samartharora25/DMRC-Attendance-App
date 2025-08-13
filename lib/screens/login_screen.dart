import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger logger = Logger();

  CameraController? _controller;
  bool _isCameraInitialized = false;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(_cameras[1], ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      logger.e("Camera initialization failed", error: e);
      _showPopup("Camera error: $e");
    }
  }

  Future<void> _scanAndSendFace() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = p.join(tempDir.path, 'temp.jpg');

      final XFile picture = await _controller!.takePicture();
      await picture.saveTo(filePath);

      logger.i("Captured image path: $filePath");
      logger.i("File exists: ${File(filePath).existsSync()}");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:5050/recognize'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          filePath,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      logger.i("Response: $respStr");

      if (!mounted) return;

      if (response.statusCode == 200) {
        if (respStr.contains("matched")) {
          final timestamp = DateTime.now().toString();
          _showPopup("✅ Face Recognized\nTime: $timestamp\nChecked In");
        } else {
          _showPopup("❌ Face Not Recognized");
        }
      } else {
        _showPopup("⚠️ Server error\n$respStr");
      }
    } catch (e) {
      logger.e("Exception occurred during face scan", error: e);
      _showPopup("❌ Error: $e");
    }
  }

  void _showPopup(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Login Status"),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: _isCameraInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _scanAndSendFace,
                    child: Text("Scan Face"),
                  )
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
