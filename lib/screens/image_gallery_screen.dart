import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageGalleryScreen extends StatefulWidget {
  const ImageGalleryScreen({super.key});

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<File> imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory(p.join(dir.path, 'DMRC'));

    if (await imageDir.exists()) {
      final images = imageDir
          .listSync()
          .where((f) => f.path.endsWith('.jpg'))
          .map((f) => File(f.path))
          .toList();

      setState(() {
        imageFiles = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registered Faces")),
      body: imageFiles.isEmpty
          ? Center(child: Text("No images found"))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: imageFiles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final file = imageFiles[index];
                final name = p.basenameWithoutExtension(file.path);
                return Column(
                  children: [
                    Expanded(
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(name, style: TextStyle(fontSize: 12)),
                  ],
                );
              },
            ),
    );
  }
}
