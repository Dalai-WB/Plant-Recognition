import 'package:flutter/material.dart';
import 'package:plant_recognition/pages/preview_screen.dart';

class PlantCard extends StatefulWidget {
  String imageUrl;
  String title;
  PlantCard({
    required this.imageUrl,
    required this.title,
    super.key,
  });

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PreviewScreen(
                plantTitle: widget.title,
                imageUrl: widget.imageUrl,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(
                    10.0,
                  ),
                ),
                child: Image(
                  image: AssetImage('assets/images/${widget.imageUrl}'),
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
