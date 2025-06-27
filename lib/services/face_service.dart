import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FaceService {
  late CameraController _cameraController;
  bool _isInitialized = false;

  // Initialize the camera
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController.initialize();
    _isInitialized = true;
  }

  CameraController get controller => _cameraController;

  bool get isInitialized => _isInitialized;

  // Capture photo and save to disk
  Future<String> captureAndSaveFaceImage(String empId) async {
    if (!_cameraController.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    final XFile file = await _cameraController.takePicture();

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String faceDirPath = path.join(appDir.path, 'faces');
    await Directory(faceDirPath).create(recursive: true);

    final String fileName = 'face_$empId.jpg';
    final String savedPath = path.join(faceDirPath, fileName);

    final File savedImage = await File(file.path).copy(savedPath);
    return savedImage.path;
  }

  // Dispose camera when done
  void disposeCamera() {
    if (_isInitialized) {
      _cameraController.dispose();
      _isInitialized = false;
    }
  }
}
