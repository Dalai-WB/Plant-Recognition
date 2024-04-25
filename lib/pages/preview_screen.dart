import 'package:flutter/material.dart';
import 'package:plant_recognition/pages/widgets/image_preview.dart';

class PreviewScreen extends StatefulWidget {
  final String plantTitle;
  final String imageUrl;
  const PreviewScreen({
    super.key,
    required this.plantTitle,
    required this.imageUrl,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Үр дүн',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagePreview(
              size: 1,
              urls: [widget.imageUrl],
            ),
            Text(
              widget.plantTitle,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'description',
            ),
          ],
        ),
      ),
    );
  }
}
