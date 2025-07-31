import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as p; 
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class CameraCaptureScreen extends StatefulWidget {
  final String name;
  final String empId;

  const CameraCaptureScreen({
    super.key,
    required this.name,
    required this.empId,
  });

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  final Logger logger = Logger();

  CameraController? _controller;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

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
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = p.join(extDir.path, 'DMRC');
    await Directory(dirPath).create(recursive: true);
    final String filePath = p.join(dirPath, '${widget.empId}_${widget.name}.jpg');

    try {
      final XFile file = await _controller!.takePicture();
      await file.saveTo(filePath);
      logger.i('Image saved to $filePath');

      if (!mounted) return;
      Navigator.pop(context, 'captured');
    } catch (e) {
      logger.e('Error capturing image', error: e);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture image")),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Capture Face")),
      body: _isCameraInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _captureImage,
                  child: Text("Capture Face"),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
