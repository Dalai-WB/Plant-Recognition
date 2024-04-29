import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:plant_recognition/pages/widgets/photo_view_screen.dart';

class ImagePreview extends StatefulWidget {
  final int size;
  final List<String> urls;
  bool isPath;

  ImagePreview({
    Key? key,
    required this.size,
    required this.urls,
    this.isPath = false,
  }) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    var matrix = [
      {
        'cross': widget.size == 1 ? 4 : 2,
        'main': 2,
      },
      {
        'cross': 2,
        'main': widget.size <= 2 ? 2 : 1,
      },
      {
        'cross': widget.size > 3 ? 1 : 2,
        'main': 1,
      },
      {
        'cross': 1,
        'main': 1,
      },
    ];
    return Column(
      children: [
        StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            ...List.generate(
              widget.size < 5 ? widget.size : 4,
              (index) {
                return StaggeredGridTile.count(
                  crossAxisCellCount: matrix[index]['cross'] ?? 4,
                  mainAxisCellCount: matrix[index]['main'] ?? 4,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoViewScreen(
                          index: index,
                          urls: widget.urls,
                          count: widget.size,
                          isPath: widget.isPath,
                        ),
                      ),
                    ),
                    child: widget.isPath
                        ? Image.file(
                            File(widget.urls[index]),
                          )
                        : Image(
                            image: AssetImage(
                              'assets/images/${widget.urls[index]}',
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
