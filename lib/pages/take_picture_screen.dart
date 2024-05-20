import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_recognition/pages/preview_screen.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.controller,
  });

  final CameraController controller;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late Future<void> _initializeControllerFuture;
  var _outputs;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = widget.controller.initialize();
    loadModel().then((value) {
      setState(() {});
    });
  }

  Future predictImagePicker() async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;
    predictImage(image);
  }

  Future predictImage(XFile image) async {
    if (image == null) return;

    String label = await classifyImage(image);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          imageUrl: image.path,
          plantTitle: label,
          isPath: true,
        ),
      ),
    );
  }

  loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/converted_model.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<String> classifyImage(XFile image) async {
    List<dynamic>? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.05,
      imageMean: 224,
      imageStd: 224,
    );
    return recognitions?.first['label'];
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(widget.controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 66,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: predictImagePicker,
              child: const ImageIcon(
                AssetImage('assets/images/gallery.png'),
                color: Colors.white,
                size: 32,
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await widget.controller.takePicture();
                  if (!context.mounted) return;
                  String label = await classifyImage(image);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PreviewScreen(
                        imageUrl: image.path,
                        plantTitle: label,
                        isPath: true,
                      ),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: const Hero(
                tag: 'image-icon',
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const Icon(
              Icons.camera_alt,
              color: Colors.black,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
